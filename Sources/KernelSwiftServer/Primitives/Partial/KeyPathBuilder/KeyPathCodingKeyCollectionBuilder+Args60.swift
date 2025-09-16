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
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C,         V65: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>, _ p65: _BP<V65>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64); cn.addPair(p65)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C,         V65: _C,         V66: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>, _ p65: _BP<V65>, _ p66: _BP<V66>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64); cn.addPair(p65); cn.addPair(p66)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C,         V65: _C,         V66: _C,         V67: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>, _ p65: _BP<V65>, _ p66: _BP<V66>, _ p67: _BP<V67>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64); cn.addPair(p65); cn.addPair(p66); cn.addPair(p67)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C,         V65: _C,         V66: _C,         V67: _C,         V68: _C
    >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>, _ p65: _BP<V65>, _ p66: _BP<V66>, _ p67: _BP<V67>, _ p68: _BP<V68>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64); cn.addPair(p65); cn.addPair(p66); cn.addPair(p67); cn.addPair(p68)
        return cn
    }
    
    public static func buildBlock<
                V01: _C,         V02: _C,         V03: _C,         V04: _C,         V05: _C,         V06: _C,         V07: _C,         V08: _C,         V09: _C,         V10: _C,
                V11: _C,         V12: _C,         V13: _C,         V14: _C,         V15: _C,         V16: _C,         V17: _C,         V18: _C,         V19: _C,         V20: _C,
                V21: _C,         V22: _C,         V23: _C,         V24: _C,         V25: _C,         V26: _C,         V27: _C,         V28: _C,         V29: _C,         V30: _C,
                V31: _C,         V32: _C,         V33: _C,         V34: _C,         V35: _C,         V36: _C,         V37: _C,         V38: _C,         V39: _C,         V40: _C,
                V41: _C,         V42: _C,         V43: _C,         V44: _C,         V45: _C,         V46: _C,         V47: _C,         V48: _C,         V49: _C,         V50: _C,
                V51: _C,         V52: _C,         V53: _C,         V54: _C,         V55: _C,         V56: _C,         V57: _C,         V58: _C,         V59: _C,         V60: _C,
                V61: _C,         V62: _C,         V63: _C,         V64: _C,         V65: _C,         V66: _C,         V67: _C,         V68: _C,         V69: _C
             >(
        _ p01: _BP<V01>, _ p02: _BP<V02>, _ p03: _BP<V03>, _ p04: _BP<V04>, _ p05: _BP<V05>, _ p06: _BP<V06>, _ p07: _BP<V07>, _ p08: _BP<V08>, _ p09: _BP<V09>, _ p10: _BP<V10>,
        _ p11: _BP<V11>, _ p12: _BP<V12>, _ p13: _BP<V13>, _ p14: _BP<V14>, _ p15: _BP<V15>, _ p16: _BP<V16>, _ p17: _BP<V17>, _ p18: _BP<V18>, _ p19: _BP<V19>, _ p20: _BP<V20>,
        _ p21: _BP<V21>, _ p22: _BP<V22>, _ p23: _BP<V23>, _ p24: _BP<V24>, _ p25: _BP<V25>, _ p26: _BP<V26>, _ p27: _BP<V27>, _ p28: _BP<V28>, _ p29: _BP<V29>, _ p30: _BP<V30>,
        _ p31: _BP<V31>, _ p32: _BP<V32>, _ p33: _BP<V33>, _ p34: _BP<V34>, _ p35: _BP<V35>, _ p36: _BP<V36>, _ p37: _BP<V37>, _ p38: _BP<V38>, _ p39: _BP<V39>, _ p40: _BP<V40>,
        _ p41: _BP<V41>, _ p42: _BP<V42>, _ p43: _BP<V43>, _ p44: _BP<V44>, _ p45: _BP<V45>, _ p46: _BP<V46>, _ p47: _BP<V47>, _ p48: _BP<V48>, _ p49: _BP<V49>, _ p50: _BP<V50>,
        _ p51: _BP<V51>, _ p52: _BP<V52>, _ p53: _BP<V53>, _ p54: _BP<V54>, _ p55: _BP<V55>, _ p56: _BP<V56>, _ p57: _BP<V57>, _ p58: _BP<V58>, _ p59: _BP<V59>, _ p60: _BP<V60>,
        _ p61: _BP<V61>, _ p62: _BP<V62>, _ p63: _BP<V63>, _ p64: _BP<V64>, _ p65: _BP<V65>, _ p66: _BP<V66>, _ p67: _BP<V67>, _ p68: _BP<V68>, _ p69: _BP<V69>
    ) -> KeyPathCodingKeyCollection<Root, CodingKeys> {
        var cn = KeyPathCodingKeyCollection<Root, CodingKeys>()
        cn.addPair(p01); cn.addPair(p02); cn.addPair(p03); cn.addPair(p04); cn.addPair(p05); cn.addPair(p06); cn.addPair(p07); cn.addPair(p08); cn.addPair(p09); cn.addPair(p10)
        cn.addPair(p11); cn.addPair(p12); cn.addPair(p13); cn.addPair(p14); cn.addPair(p15); cn.addPair(p16); cn.addPair(p17); cn.addPair(p18); cn.addPair(p19); cn.addPair(p20)
        cn.addPair(p21); cn.addPair(p22); cn.addPair(p23); cn.addPair(p24); cn.addPair(p25); cn.addPair(p26); cn.addPair(p27); cn.addPair(p28); cn.addPair(p29); cn.addPair(p30)
        cn.addPair(p31); cn.addPair(p32); cn.addPair(p33); cn.addPair(p34); cn.addPair(p35); cn.addPair(p36); cn.addPair(p37); cn.addPair(p38); cn.addPair(p39); cn.addPair(p40)
        cn.addPair(p41); cn.addPair(p42); cn.addPair(p43); cn.addPair(p44); cn.addPair(p45); cn.addPair(p46); cn.addPair(p47); cn.addPair(p48); cn.addPair(p49); cn.addPair(p50)
        cn.addPair(p51); cn.addPair(p52); cn.addPair(p53); cn.addPair(p54); cn.addPair(p55); cn.addPair(p56); cn.addPair(p57); cn.addPair(p58); cn.addPair(p59); cn.addPair(p60)
        cn.addPair(p61); cn.addPair(p62); cn.addPair(p63); cn.addPair(p64); cn.addPair(p65); cn.addPair(p66); cn.addPair(p67); cn.addPair(p68); cn.addPair(p69)
        return cn
    }
}
