//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/04/2023.
//

import Foundation

extension KeyPathCodingKeyCollection.Builder {
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49)
        return cn
    }
}
