//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/09/2024.
//

import FluentSQL

extension KernelFluentPostGIS {
    public enum FunctionName: String, CaseIterable, Codable, Equatable {
        case contains = "ST_Contains"
        case crosses = "ST_Crosses"
        case disjoint = "ST_Disjoint"
        case distance = "ST_Distance"
        case distanceWithin = "ST_DWithin"
        case equals = "ST_Equals"
        case intersects = "ST_Intersects"
        case overlaps = "ST_Overlaps"
        case touches = "ST_Touches"
        case within = "ST_Within"
    }
    
    public enum FilterPrecedence {
        case left
        case right
    }
    
    public enum FilterFunction<Model, Field, Value> where Field: QueryableProperty, Field.Model == Model, Model: FluentKit.Model, Value: PostGISCodable {
        case contains(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case crosses(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case disjoint(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case distanceWithin(
            _ field: KeyPath<Model, Field>,
            _ value: Value,
            _ distance: Double,
            _ precedence: FilterPrecedence = .left
        )
        case equals(_ field: KeyPath<Model, Field>, _ value: Value)
        case intersects(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case overlaps(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case touches(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
        case within(_ field: KeyPath<Model, Field>, _ value: Value, _ precedence: FilterPrecedence = .left)
    }
    
    public enum SortFunction<Model, Field, Value> where Field: QueryableProperty, Field.Model == Model, Model: FluentKit.Model, Value: PostGISCodable {
        case distance(_ field: KeyPath<Model, Field>, _ value: Value)
    }
    
    public static func geometryQueryExpression<T: PostGISCodable>(_ geometry: T) -> SQLExpression {
        SQLFunction("ST_GeomFromEWKB", args: [SQLBind(geometry.binaryEncoded())])
    }
    
    public static func geographyQueryExpression<T: PostGISCodable>(_ geometry: T) -> SQLExpression {
        SQLFunction("ST_GeogFromEWKB", args: [SQLBind(geometry.binaryEncoded())])
    }
}

extension KernelFluentPostGIS.FilterFunction {
    public func functionName() -> KernelFluentPostGIS.FunctionName {
        switch self {
        case .contains: .contains
        case .crosses: .crosses
        case .disjoint: .disjoint
        case .distanceWithin: .distanceWithin
        case .equals: .equals
        case .intersects: .intersects
        case .overlaps: .overlaps
        case .touches: .touches
        case .within: .within
        }
    }
    
    public func sqlExpressions() -> [SQLExpression] {
        switch self {
        case
            let .contains(field, value, precedence),
            let .crosses(field, value, precedence),
            let .disjoint(field, value, precedence),
            let .intersects(field, value, precedence),
            let .overlaps(field, value, precedence),
            let .touches(field, value, precedence),
            let .within(field, value, precedence)
        :
            let path = QueryBuilder.fieldPath(field)
            let geometryValue = KernelFluentPostGIS.geometryQueryExpression(value)
            return precedence == .left ? [path, geometryValue] : [geometryValue, path]

        case let .equals(field, value):
            let path = QueryBuilder.fieldPath(field)
            let geometryValue = KernelFluentPostGIS.geometryQueryExpression(value)
            return [path, geometryValue]
        
        case let .distanceWithin(field, value, distance, precedence):
            let path = QueryBuilder.fieldPath(field)
            let geometryValue = KernelFluentPostGIS.geometryQueryExpression(value)
            let distanceValue = SQLLiteral.numeric(.init(distance))
            return precedence == .left ? [path, geometryValue, distanceValue] : [geometryValue, path, distanceValue]
        }
    }
}

extension KernelFluentPostGIS.SortFunction {
    public func functionName() -> KernelFluentPostGIS.FunctionName {
        switch self {
        case .distance: .distance
        }
    }
    
    public func sqlExpressions() -> [SQLExpression] {
        switch self {
        case let .distance(field, value):
            let path = QueryBuilder.fieldPath(field)
            let geometryValue = KernelFluentPostGIS.geometryQueryExpression(value)
            return [path, geometryValue]
        }
    }
}

// st_3dclosestpoint
// st_3ddfullywithin
// st_3ddistance
// st_3ddwithin
// st_3dextent
// st_3dintersects
// st_3dlength
// st_3dlineinterpolatepoint
// st_3dlongestline
// st_3dmakebox
// st_3dmaxdistance
// st_3dperimeter
// st_3dshortestline
// st_addmeasure
// st_addpoint
// st_addpoint
// st_affine
// st_affine
// st_angle
// st_angle
// st_area
// st_area
// st_area
// st_area2d
// st_asbinary
// st_asbinary
// st_asbinary
// st_asbinary
// st_asencodedpolyline
// st_asewkb
// st_asewkb
// st_asewkt
// st_asewkt
// st_asewkt
// st_asewkt
// st_asewkt
// st_asflatgeobuf
// st_asflatgeobuf
// st_asflatgeobuf
// st_asgeobuf
// st_asgeobuf
// st_asgeojson
// st_asgeojson
// st_asgeojson
// st_asgeojson
// st_asgml
// st_asgml
// st_asgml
// st_asgml
// st_asgml
// st_ashexewkb
// st_ashexewkb
// st_askml
// st_askml
// st_askml
// st_aslatlontext
// st_asmarc21
// st_asmvt
// st_asmvt
// st_asmvt
// st_asmvt
// st_asmvt
// st_asmvtgeom
// st_assvg
// st_assvg
// st_assvg
// st_astext
// st_astext
// st_astext
// st_astext
// st_astext
// st_astwkb
// st_astwkb
// st_asx3d
// st_azimuth
// st_azimuth
// st_bdmpolyfromtext
// st_bdpolyfromtext
// st_boundary
// st_boundingdiagonal
// st_box2dfromgeohash
// st_buffer
// st_buffer
// st_buffer
// st_buffer
// st_buffer
// st_buffer
// st_buffer
// st_buffer
// st_buildarea
// st_centroid
// st_centroid
// st_centroid
// st_chaikinsmoothing
// st_cleangeometry
// st_clipbybox2d
// st_closestpoint
// st_closestpoint
// st_closestpoint
// st_closestpointofapproach
// st_clusterdbscan
// st_clusterintersecting
// st_clusterintersecting
// st_clusterintersectingwin
// st_clusterkmeans
// st_clusterwithin
// st_clusterwithin
// st_clusterwithinwin
// st_collect
// st_collect
// st_collect
// st_collectionextract
// st_collectionextract
// st_collectionhomogenize
// st_combinebbox
// st_combinebbox
// st_combinebbox
// st_concavehull
// st_contains
// st_containsproperly
// st_convexhull
// st_coorddim
// st_coverageinvalidedges
// st_coveragesimplify
// st_coverageunion
// st_coverageunion
// st_coveredby
// st_coveredby
// st_coveredby
// st_covers
// st_covers
// st_covers
// st_cpawithin
// st_crosses
// st_curvetoline
// st_delaunaytriangles
// st_dfullywithin
// st_difference
// st_dimension
// st_disjoint
// st_distance
// st_distance
// st_distance
// st_distancecpa
// st_distancesphere
// st_distancesphere
// st_distancespheroid
// st_distancespheroid
// st_dump
// st_dumppoints
// st_dumprings
// st_dumpsegments
// st_dwithin
// st_dwithin
// st_dwithin
// st_endpoint
// st_envelope
// st_equals
// st_estimatedextent
// st_estimatedextent
// st_estimatedextent
// st_expand
// st_expand
// st_expand
// st_expand
// st_expand
// st_expand
// st_extent
// st_exteriorring
// st_filterbym
// st_findextent
// st_findextent
// st_flipcoordinates
// st_force2d
// st_force3d
// st_force3dm
// st_force3dz
// st_force4d
// st_forcecollection
// st_forcecurve
// st_forcepolygonccw
// st_forcepolygoncw
// st_forcerhr
// st_forcesfs
// st_forcesfs
// st_frechetdistance
// st_fromflatgeobuf
// st_fromflatgeobuftotable
// st_generatepoints
// st_generatepoints
// st_geogfromtext
// st_geogfromwkb
// st_geographyfromtext
// st_geohash
// st_geohash
// st_geomcollfromtext
// st_geomcollfromtext
// st_geomcollfromwkb
// st_geomcollfromwkb
// st_geometricmedian
// st_geometryfromtext
// st_geometryfromtext
// st_geometryn
// st_geometrytype
// st_geomfromewkb
// st_geomfromewkt
// st_geomfromgeohash
// st_geomfromgeojson
// st_geomfromgeojson
// st_geomfromgeojson
// st_geomfromgml
// st_geomfromgml
// st_geomfromkml
// st_geomfrommarc21
// st_geomfromtext
// st_geomfromtext
// st_geomfromtwkb
// st_geomfromwkb
// st_geomfromwkb
// st_gmltosql
// st_gmltosql
// st_hasarc
// st_hausdorffdistance
// st_hausdorffdistance
// st_hexagon
// st_hexagongrid
// st_interiorringn
// st_interpolatepoint
// st_intersection
// st_intersection
// st_intersection
// st_intersects
// st_intersects
// st_intersects
// st_inversetransformpipeline
// st_isclosed
// st_iscollection
// st_isempty
// st_ispolygonccw
// st_ispolygoncw
// st_isring
// st_issimple
// st_isvalid
// st_isvalid
// st_isvaliddetail
// st_isvalidreason
// st_isvalidreason
// st_isvalidtrajectory
// st_largestemptycircle
// st_length
// st_length
// st_length
// st_length2d
// st_length2dspheroid
// st_lengthspheroid
// st_letters
// st_linecrossingdirection
// st_lineextend
// st_linefromencodedpolyline
// st_linefrommultipoint
// st_linefromtext
// st_linefromtext
// st_linefromwkb
// st_linefromwkb
// st_lineinterpolatepoint
// st_lineinterpolatepoint
// st_lineinterpolatepoint
// st_lineinterpolatepoints
// st_lineinterpolatepoints
// st_lineinterpolatepoints
// st_linelocatepoint
// st_linelocatepoint
// st_linelocatepoint
// st_linemerge
// st_linemerge
// st_linestringfromwkb
// st_linestringfromwkb
// st_linesubstring
// st_linesubstring
// st_linesubstring
// st_linetocurve
// st_locatealong
// st_locatebetween
// st_locatebetweenelevations
// st_longestline
// st_m
// st_makebox2d
// st_makeenvelope
// st_makeline
// st_makeline
// st_makeline
// st_makepoint
// st_makepoint
// st_makepoint
// st_makepointm
// st_makepolygon
// st_makepolygon
// st_makevalid
// st_makevalid
// st_maxdistance
// st_maximuminscribedcircle
// st_memcollect
// st_memsize
// st_memunion
// st_minimumboundingcircle
// st_minimumboundingradius
// st_minimumclearance
// st_minimumclearanceline
// st_mlinefromtext
// st_mlinefromtext
// st_mlinefromwkb
// st_mlinefromwkb
// st_mpointfromtext
// st_mpointfromtext
// st_mpointfromwkb
// st_mpointfromwkb
// st_mpolyfromtext
// st_mpolyfromtext
// st_mpolyfromwkb
// st_mpolyfromwkb
// st_multi
// st_multilinefromwkb
// st_multilinestringfromtext
// st_multilinestringfromtext
// st_multipointfromtext
// st_multipointfromwkb
// st_multipointfromwkb
// st_multipolyfromwkb
// st_multipolyfromwkb
// st_multipolygonfromtext
// st_multipolygonfromtext
// st_ndims
// st_node
// st_normalize
// st_npoints
// st_nrings
// st_numgeometries
// st_numinteriorring
// st_numinteriorrings
// st_numpatches
// st_numpoints
// st_offsetcurve
// st_orderingequals
// st_orientedenvelope
// st_overlaps
// st_patchn
// st_perimeter
// st_perimeter
// st_perimeter2d
// st_point
// st_point
// st_pointfromgeohash
// st_pointfromtext
// st_pointfromtext
// st_pointfromwkb
// st_pointfromwkb
// st_pointinsidecircle
// st_pointm
// st_pointn
// st_pointonsurface
// st_points
// st_pointz
// st_pointzm
// st_polyfromtext
// st_polyfromtext
// st_polyfromwkb
// st_polyfromwkb
// st_polygon
// st_polygonfromtext
// st_polygonfromtext
// st_polygonfromwkb
// st_polygonize
// st_polygonize
// st_project
// st_project
// st_project
// st_project
// st_quantizecoordinates
// st_reduceprecision
// st_relate
// st_relate
// st_relate
// st_relatematch
// st_removepoint
// st_removerepeatedpoints
// st_reverse
// st_rotate
// st_rotate
// st_rotate
// st_rotatex
// st_rotatey
// st_rotatez
// st_scale
// st_scale
// st_scale
// st_scale
// st_scroll
// st_segmentize
// st_segmentize
// st_seteffectivearea
// st_setpoint
// st_setsrid
// st_setsrid
// st_sharedpaths
// st_shiftlongitude
// st_shortestline
// st_shortestline
// st_shortestline
// st_simplify
// st_simplify
// st_simplifypolygonhull
// st_simplifypreservetopology
// st_simplifyvw
// st_snap
// st_snaptogrid
// st_snaptogrid
// st_snaptogrid
// st_snaptogrid
// st_split
// st_square
// st_squaregrid
// st_srid
// st_srid
// st_startpoint
// st_subdivide
// st_summary
// st_summary
// st_swapordinates
// st_symdifference
// st_symmetricdifference
// st_tileenvelope
// st_touches
// st_transform
// st_transform
// st_transform
// st_transform
// st_transformpipeline
// st_translate
// st_translate
// st_transscale
// st_triangulatepolygon
// st_unaryunion
// st_union
// st_union
// st_union
// st_union
// st_union
// st_voronoilines
// st_voronoipolygons
// st_within
// st_wkbtosql
// st_wkttosql
// st_wrapx
// st_x
// st_xmax
// st_xmin
// st_y
// st_ymax
// st_ymin
// st_z
// st_zmax
// st_zmflag
// st_zmin
