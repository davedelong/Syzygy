//
//  Entitlements.m
//  SyzygyCore
//
//  Created by Dave DeLong on 1/10/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "Entitlements.h"
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

// adapted from https://opensource.apple.com/source/Security/Security-55471/sec/Security/Tool/codesign.c

/*
 * Structure of an embedded-signature MultiBlob (called a SuperBlob in the codesign source)
 */
typedef struct __BlobIndex {
    uint32_t type;                   /* type of entry */
    uint32_t offset;                 /* offset of entry */
} CS_Blob;

typedef struct __MultiBlob {
    uint32_t magic;                  /* magic number */
    uint32_t length;                 /* total length of SuperBlob */
    uint32_t count;                  /* number of index entries following */
    CS_Blob index[];                 /* (count) entries */
    /* followed by Blobs in no particular order as indicated by offsets in index */
} CS_MultiBlob;

NSData *ReadEntitlementsFromTEXT(const struct mach_header *executable) {
    uint32_t dataOffset;
    uint64_t dataLength;
    
    BOOL is64bit = executable->magic == MH_MAGIC_64 || executable->magic == MH_CIGAM_64;
    if (is64bit) {
        const struct section_64 *section = getsectbynamefromheader_64((const struct mach_header_64 *)executable, "__TEXT", "__entitlements");
        dataOffset = section->offset;
        dataLength = section->size;
    } else {
        const struct section *section = getsectbynamefromheader(executable, "__TEXT", "__entitlements");
        dataOffset = section->offset;
        dataLength = (uint64_t)section->size;
    }
    
    uintptr_t dataStart = (uintptr_t)executable + dataOffset;
    return [NSData dataWithBytes:(const void *)dataStart length:dataLength];
}

NSData *ReadEntitlementsFromCodeSignature(const struct mach_header *executable) {
    
    BOOL is64bit = executable->magic == MH_MAGIC_64 || executable->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executable + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    
    const struct segment_command *segmentCommand = NULL;
    const struct segment_command *entitlementsSegment = NULL;
    for (uint32_t i = 0; i < executable->ncmds && entitlementsSegment == NULL; i++, cursor += segmentCommand->cmdsize) {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_CODE_SIGNATURE) { entitlementsSegment = segmentCommand; }
    }
    
    if (entitlementsSegment == NULL) { return nil; }
    
    const struct linkedit_data_command *dataCommand = (const struct linkedit_data_command *)entitlementsSegment;
    
    uintptr_t dataStart = (uintptr_t)executable + dataCommand->dataoff;
    CS_MultiBlob *multiBlob = (CS_MultiBlob *)dataStart;
    if (ntohl(multiBlob->magic) != 0xfade0cc0) { return nil; }
    
    uint32_t count = CFSwapInt32BigToHost(multiBlob->count);
    for (int i = 0; i < count; i++) {
        uint32_t blobOffset = CFSwapInt32BigToHost(multiBlob->index[i].offset);
        uintptr_t blobBytes = dataStart + blobOffset;
        uint32_t blobMagic = CFSwapInt32BigToHost(*(uint32_t *)blobBytes);
        if (blobMagic != 0xfade7171) { continue; }
        
        // the first 4 bytes are the magic
        // the next 4 are the length
        // after that is the encoded plist
        uint32_t blobLength = CFSwapInt32BigToHost(*(uint32_t *)(blobBytes + 4));
        return [NSData dataWithBytes:(const void *)(blobBytes + 8) length:(blobLength - 8)];
    }
    return nil;
}

extern NSData *EntitlementsData(void) {
    
    // we don't care about mach_header vs mach_header_64 because we only care about the filetype field,
    // which is at the same offset in both structs
    const struct mach_header *executable = NULL;
    for (uint32_t i = 0; i < _dyld_image_count() && executable == NULL; i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) { executable = header; }
    }
    
    if (executable == NULL) { return nil; }
    
    NSData *entitlements = ReadEntitlementsFromCodeSignature(executable);
    if (entitlements != nil) { return entitlements; }
    
    entitlements = ReadEntitlementsFromTEXT(executable);
    if (entitlements != nil) { return entitlements; }
    
    return nil;
}
