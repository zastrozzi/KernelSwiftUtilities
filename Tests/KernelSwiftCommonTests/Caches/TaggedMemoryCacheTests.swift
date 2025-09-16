//
//  MultiTaggedMemoryCacheTests.swift
//
//
//  Created by Jimmy Hough Jr on 11/16/23.
//
import KernelSwiftCommon
import Testing
import Foundation

typealias Lock = KernelSwiftCommon.Concurrency.Core.CriticalLock
typealias EscSeq = UInt8.StandardIn.EscapedSequence

@Suite
struct TaggedMemoryCacheTests {
    @Test
    func testInit() {
        let testSubject = KernelSwiftCommon.TaggedMemoryCache<EscSeq, UUID, Int, Lock>()
        #expect(testSubject.count == 0, "Should initialize empty.")
    }
    
    @Test
    func testSetValue() {
        let testSubject = KernelSwiftCommon.TaggedMemoryCache<EscSeq, UUID, Int, Lock>()
        let expectedKey = UUID()
        let expectedValue: Int = 1
        
        let expectedTags: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2), .std_in(EscSeq.fn3)]
        
        testSubject.set(expectedKey, tags: expectedTags, value: expectedValue)
        let tagsForKey = testSubject.tags(for: expectedKey)
        
        #expect(tagsForKey.count == expectedTags.count)
    }
    
    @Test
    func testClosestKey() {
        let testSubject = KernelSwiftCommon.TaggedMemoryCache<EscSeq, UUID, Int, Lock>()
        let key1 = UUID()
        let key2 = UUID()
        let key3 = UUID()
        let key4 = UUID()
        let value1: Int = 1
        let value2: Int = 2
        let value3: Int = 3
        let value4: Int = 4
        
        let tagSequence1: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2), .std_in(EscSeq.fn3)]
        let tagSequence2: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5), .std_in(EscSeq.fn6)]
        let tagSequence3: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn3), .std_in(EscSeq.fn4)]
        let tagSequence4: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        
        let testSequence1: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5)]
        let testSequence2: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2)]
        let testSequence3: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        let testSequence4: Set<EscSeq> = [.std_in(EscSeq.fn1)]
        
        testSubject.set(key4, tags: tagSequence4, value: value4)
        testSubject.set(key3, tags: tagSequence3, value: value3)
        testSubject.set(key2, tags: tagSequence2, value: value2)
        testSubject.set(key1, tags: tagSequence1, value: value1)
        
        let closestKey1 = testSubject.closestKey(for: testSequence1)
        let closestKey2 = testSubject.closestKey(for: testSequence2)
        let closestKey3 = testSubject.closestKey(for: testSequence3)
        let closestKey4 = testSubject.closestKey(for: testSequence4)
        let closestValue1 = testSubject.takeFirst(for: testSequence1)
        let closestValue2 = testSubject.takeFirst(for: testSequence2)
        let closestValue3 = testSubject.takeFirst(for: testSequence3)
        let closestValue4 = testSubject.takeFirst(for: testSequence4)
        
        #expect(closestKey1 == key2)
        #expect(closestKey2 == key1)
        #expect(closestKey3 == key4)
        #expect([key1, key3, key4].contains(closestKey4))
        #expect(closestValue1 == value2)
        #expect(closestValue2 == value1)
        #expect(closestValue3 == value4)
        #expect([value1, value3, value4].contains(closestValue4))
    }
    
    @Test
    func testKeysInclusive() {
        let testSubject = KernelSwiftCommon.TaggedMemoryCache<EscSeq, UUID, Int, Lock>()
        let key1 = UUID()
        let key2 = UUID()
        let key3 = UUID()
        let key4 = UUID()
        let value1: Int = 1
        let value2: Int = 2
        let value3: Int = 3
        let value4: Int = 4
        
        let tagSequence1: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2), .std_in(EscSeq.fn3)]
        let tagSequence2: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5), .std_in(EscSeq.fn6)]
        let tagSequence3: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn3), .std_in(EscSeq.fn4)]
        let tagSequence4: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        
        let testSequence1: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5)]
        let testSequence2: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2)]
        let testSequence3: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        let testSequence4: Set<EscSeq> = [.std_in(EscSeq.fn1)]
        
        testSubject.set(key4, tags: tagSequence4, value: value4)
        testSubject.set(key3, tags: tagSequence3, value: value3)
        testSubject.set(key2, tags: tagSequence2, value: value2)
        testSubject.set(key1, tags: tagSequence1, value: value1)
        
        let keysInclusive1 = testSubject.keys(for: tagSequence1)
        let keysInclusive2 = testSubject.keys(for: tagSequence2)
        let keysInclusive3 = testSubject.keys(for: tagSequence3)
        let keysInclusive4 = testSubject.keys(for: tagSequence4)
        let keysInclusive5 = testSubject.keys(for: testSequence1)
        let keysInclusive6 = testSubject.keys(for: testSequence2)
        let keysInclusive7 = testSubject.keys(for: testSequence3)
        let keysInclusive8 = testSubject.keys(for: testSequence4)
        
        #expect(Set(keysInclusive1) == Set([key1, key3, key4]))
        #expect(Set(keysInclusive2) == Set([key2, key3, key4]))
        #expect(Set(keysInclusive3) == Set([key1, key2, key3, key4]))
        #expect(Set(keysInclusive4) == Set([key1, key2, key3, key4]))
        #expect(Set(keysInclusive5) == Set([key2, key3, key4]))
        #expect(Set(keysInclusive6) == Set([key1, key3, key4]))
        #expect(Set(keysInclusive7) == Set([key1, key2, key3, key4]))
        #expect(Set(keysInclusive8) == Set([key1, key3, key4]))
    }
    
    @Test
    func testKeysExclusive() {
        let testSubject = KernelSwiftCommon.TaggedMemoryCache<EscSeq, UUID, Int, Lock>()
        let key1 = UUID()
        let key2 = UUID()
        let key3 = UUID()
        let key4 = UUID()
        let value1: Int = 1
        let value2: Int = 2
        let value3: Int = 3
        let value4: Int = 4
        
        let tagSequence1: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2), .std_in(EscSeq.fn3)]
        let tagSequence2: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5), .std_in(EscSeq.fn6)]
        let tagSequence3: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn3), .std_in(EscSeq.fn4)]
        let tagSequence4: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        
        let testSequence1: Set<EscSeq> = [.std_in(EscSeq.fn4), .std_in(EscSeq.fn5)]
        let testSequence2: Set<EscSeq> = [.std_in(EscSeq.fn1), .std_in(EscSeq.fn2)]
        let testSequence3: Set<EscSeq> = [
            .std_in(EscSeq.fn1),
            .std_in(EscSeq.fn2),
            .std_in(EscSeq.fn3),
            .std_in(EscSeq.fn4),
            .std_in(EscSeq.fn5),
            .std_in(EscSeq.fn6)
        ]
        let testSequence4: Set<EscSeq> = [.std_in(EscSeq.fn1)]
        
        testSubject.set(key4, tags: tagSequence4, value: value4)
        testSubject.set(key3, tags: tagSequence3, value: value3)
        testSubject.set(key2, tags: tagSequence2, value: value2)
        testSubject.set(key1, tags: tagSequence1, value: value1)
        
        let keysExclusive1 = testSubject.keys(for: tagSequence1, mode: .exclusive)
        let keysExclusive2 = testSubject.keys(for: tagSequence2, mode: .exclusive)
        let keysExclusive3 = testSubject.keys(for: tagSequence3, mode: .exclusive)
        let keysExclusive4 = testSubject.keys(for: tagSequence4, mode: .exclusive)
        let keysExclusive5 = testSubject.keys(for: testSequence1, mode: .exclusive)
        let keysExclusive6 = testSubject.keys(for: testSequence2, mode: .exclusive)
        let keysExclusive7 = testSubject.keys(for: testSequence3, mode: .exclusive)
        let keysExclusive8 = testSubject.keys(for: testSequence4, mode: .exclusive)
        
        #expect(Set(keysExclusive1) == Set([key1, key4]))
        #expect(Set(keysExclusive2) == Set([key2, key4]))
        #expect(Set(keysExclusive3) == Set([key3, key4]))
        #expect(Set(keysExclusive4) == Set([key4]))
        #expect(Set(keysExclusive5) == Set([key2, key4]))
        #expect(Set(keysExclusive6) == Set([key1, key4]))
        #expect(Set(keysExclusive7) == Set([key4]))
        #expect(Set(keysExclusive8) == Set([key1, key3, key4]))
    }
}
