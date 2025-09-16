//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/04/2023.
//

import Foundation

extension KeyPathCodingKeyCollection.Builder where Root: PartialCodable, Root.CodingKeys == CodingKeys {
    public static func buildBlock<
                V01: _C
    >(
        _ p01: _BP<V01>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C
    >(
        _ p01: _TBP<Root, V01>, _ p02: _TBP<Root, V02>, _ p03: _TBP<Root, V03>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C
    >(
        _ p01: _TBP<Root, V01>, _ p02: _TBP<Root, V02>, _ p03: _TBP<Root, V03>, _ p04: _TBP<Root, V04>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>
    ) -> KeyPathCodingKeyCollection<Root, Root.CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, Root.CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09)
        return cn
    }
}
