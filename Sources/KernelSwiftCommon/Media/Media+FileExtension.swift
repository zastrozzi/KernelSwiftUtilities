//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

extension KernelSwiftCommon.Media {
    public enum FileExtension: String, Codable, Equatable, CaseIterable, Sendable {
        case ez // "ez": HTTPMediaType(type: "application", subType: "andrew-inset"),
        case anx // "anx": HTTPMediaType(type: "application", subType: "annodex"),
        case atom // "atom": HTTPMediaType(type: "application", subType: "atom+xml"),
        case atomcat // "atomcat": HTTPMediaType(type: "application", subType: "atomcat+xml"),
        case atomsrv // "atomsrv": HTTPMediaType(type: "application", subType: "atomserv+xml"),
        case lin // "lin": HTTPMediaType(type: "application", subType: "bbolin"),
        case cu // "cu": HTTPMediaType(type: "application", subType: "cu-seeme"),
        case davmount // "davmount": HTTPMediaType(type: "application", subType: "davmount+xml"),
        case dcm // "dcm": HTTPMediaType(type: "application", subType: "dicom"),
        case tsp // "tsp": HTTPMediaType(type: "application", subType: "dsptype"),
        case es // "es": HTTPMediaType(type: "application", subType: "ecmascript"),
        case spl // "spl": HTTPMediaType(type: "application", subType: "futuresplash"),
        case hta // "hta": HTTPMediaType(type: "application", subType: "hta"),
        case jar // "jar": HTTPMediaType(type: "application", subType: "java-archive"),
        case ser // "ser": HTTPMediaType(type: "application", subType: "java-serialized-object"),
        case `class` = "class" // "class": HTTPMediaType(type: "application", subType: "java-vm"),
        case js // "js": HTTPMediaType(type: "application", subType: "javascript"),
        case mjs // "mjs": HTTPMediaType(type: "application", subType: "javascript"),
        case json // "json": HTTPMediaType(type: "application", subType: "json"),
        case m3g // "m3g": HTTPMediaType(type: "application", subType: "m3g"),
        case hqx // "hqx": HTTPMediaType(type: "application", subType: "mac-binhex40"),
        case cpt // "cpt": HTTPMediaType(type: "application", subType: "mac-compactpro"),
        case nb // "nb": HTTPMediaType(type: "application", subType: "mathematica"),
        case nbp // "nbp": HTTPMediaType(type: "application", subType: "mathematica"),
        case mbox // "mbox": HTTPMediaType(type: "application", subType: "mbox"),
        case mdb // "mdb": HTTPMediaType(type: "application", subType: "msaccess"),
        case doc // "doc": HTTPMediaType(type: "application", subType: "msword"),
        case dot // "dot": HTTPMediaType(type: "application", subType: "msword"),
        case mxf // "mxf": HTTPMediaType(type: "application", subType: "mxf"),
        case bin // "bin": HTTPMediaType(type: "application", subType: "octet-stream"),
        case oda // "oda": HTTPMediaType(type: "application", subType: "oda"),
        case ogx // "ogx": HTTPMediaType(type: "application", subType: "ogg"),
        case one // "one": HTTPMediaType(type: "application", subType: "onenote"),
        case onetoc2 // "onetoc2": HTTPMediaType(type: "application", subType: "onenote"),
        case onetmp // "onetmp": HTTPMediaType(type: "application", subType: "onenote"),
        case onepkg // "onepkg": HTTPMediaType(type: "application", subType: "onenote"),
        case pdf // "pdf": HTTPMediaType(type: "application", subType: "pdf"),
        case pgp // "pgp": HTTPMediaType(type: "application", subType: "pgp-encrypted"),
        case key // "key": HTTPMediaType(type: "application", subType: "pgp-keys"),
        case sig // "sig": HTTPMediaType(type: "application", subType: "pgp-signature"),
        case prf // "prf": HTTPMediaType(type: "application", subType: "pics-rules"),
        case ps // "ps": HTTPMediaType(type: "application", subType: "postscript"),
        case ai // "ai": HTTPMediaType(type: "application", subType: "postscript"),
        case eps // "eps": HTTPMediaType(type: "application", subType: "postscript"),
        case epsi // "epsi": HTTPMediaType(type: "application", subType: "postscript"),
        case epsf // "epsf": HTTPMediaType(type: "application", subType: "postscript"),
        case eps2 // "eps2": HTTPMediaType(type: "application", subType: "postscript"),
        case eps3 // "eps3": HTTPMediaType(type: "application", subType: "postscript"),
        case rar // "rar": HTTPMediaType(type: "application", subType: "rar"),
        case rdf // "rdf": HTTPMediaType(type: "application", subType: "rdf+xml"),
        case rtf // "rtf": HTTPMediaType(type: "application", subType: "rtf"),
        case stl // "stl": HTTPMediaType(type: "application", subType: "sla"),
        case smi // "smi": HTTPMediaType(type: "application", subType: "smil+xml"),
        case smil // "smil": HTTPMediaType(type: "application", subType: "smil+xml"),
        case xhtml // "xhtml": HTTPMediaType(type: "application", subType: "xhtml+xml"),
        case xht // "xht": HTTPMediaType(type: "application", subType: "xhtml+xml"),
        case xml // "xml": HTTPMediaType(type: "application", subType: "xml"),
        case xsd // "xsd": HTTPMediaType(type: "application", subType: "xml"),
        case xsl // "xsl": HTTPMediaType(type: "application", subType: "xslt+xml"),
        case xslt // "xslt": HTTPMediaType(type: "application", subType: "xslt+xml"),
        case xspf // "xspf": HTTPMediaType(type: "application", subType: "xspf+xml"),
        case zip // "zip": HTTPMediaType(type: "application", subType: "zip"),
        case apk // "apk": HTTPMediaType(type: "application", subType: "vnd.android.package-archive"),
        case cdy // "cdy": HTTPMediaType(type: "application", subType: "vnd.cinderella"),
        case kml // "kml": HTTPMediaType(type: "application", subType: "vnd.google-earth.kml+xml"),
        case kmz // "kmz": HTTPMediaType(type: "application", subType: "vnd.google-earth.kmz"),
        case xul // "xul": HTTPMediaType(type: "application", subType: "vnd.mozilla.xul+xml"),
        case xls // "xls": HTTPMediaType(type: "application", subType: "vnd.ms-excel"),
        case xlb // "xlb": HTTPMediaType(type: "application", subType: "vnd.ms-excel"),
        case xlt // "xlt": HTTPMediaType(type: "application", subType: "vnd.ms-excel"),
        case xlam // "xlam": HTTPMediaType(type: "application", subType: "vnd.ms-excel.addin.macroEnabled.12"),
        case xlsb // "xlsb": HTTPMediaType(type: "application", subType: "vnd.ms-excel.sheet.binary.macroEnabled.12"),
        case xlsm // "xlsm": HTTPMediaType(type: "application", subType: "vnd.ms-excel.sheet.macroEnabled.12"),
        case xltm // "xltm": HTTPMediaType(type: "application", subType: "vnd.ms-excel.template.macroEnabled.12"),
        case eot // "eot": HTTPMediaType(type: "application", subType: "vnd.ms-fontobject"),
        case thmx // "thmx": HTTPMediaType(type: "application", subType: "vnd.ms-officetheme"),
        case cat // "cat": HTTPMediaType(type: "application", subType: "vnd.ms-pki.seccat"),
        case ppt // "ppt": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint"),
        case pps // "pps": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint"),
        case ppam // "ppam": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint.addin.macroEnabled.12"),
        case pptm // "pptm": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint.presentation.macroEnabled.12"),
        case sldm // "sldm": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint.slide.macroEnabled.12"),
        case ppsm // "ppsm": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint.slideshow.macroEnabled.12"),
        case potm // "potm": HTTPMediaType(type: "application", subType: "vnd.ms-powerpoint.template.macroEnabled.12"),
        case docm // "docm": HTTPMediaType(type: "application", subType: "vnd.ms-word.document.macroEnabled.12"),
        case dotm // "dotm": HTTPMediaType(type: "application", subType: "vnd.ms-word.template.macroEnabled.12"),
        case odc // "odc": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.chart"),
        case odb // "odb": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.database"),
        case odf // "odf": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.formula"),
        case odg // "odg": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.graphics"),
        case otg // "otg": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.graphics-template"),
        case odi // "odi": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.image"),
        case odp // "odp": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.presentation"),
        case otp // "otp": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.presentation-template"),
        case ods // "ods": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.spreadsheet"),
        case ots // "ots": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.spreadsheet-template"),
        case odt // "odt": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.text"),
        case odm // "odm": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.text-master"),
        case ott // "ott": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.text-template"),
        case oth // "oth": HTTPMediaType(type: "application", subType: "vnd.oasis.opendocument.text-web"),
        case pptx // "pptx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.presentationml.presentation"),
        case sldx // "sldx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.presentationml.slide"),
        case ppsx // "ppsx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.presentationml.slideshow"),
        case potx // "potx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.presentationml.template"),
        case xlsx // "xlsx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
        case xltx // "xltx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.spreadsheetml.template"),
        case docx // "docx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.wordprocessingml.document"),
        case dotx // "dotx": HTTPMediaType(type: "application", subType: "vnd.openxmlformats-officedocument.wordprocessingml.template"),
        case cod // "cod": HTTPMediaType(type: "application", subType: "vnd.rim.cod"),
        case mmf // "mmf": HTTPMediaType(type: "application", subType: "vnd.smaf"),
        case sdc // "sdc": HTTPMediaType(type: "application", subType: "vnd.stardivision.calc"),
        case sds // "sds": HTTPMediaType(type: "application", subType: "vnd.stardivision.chart"),
        case sda // "sda": HTTPMediaType(type: "application", subType: "vnd.stardivision.draw"),
        case sdd // "sdd": HTTPMediaType(type: "application", subType: "vnd.stardivision.impress"),
        case sdf // "sdf": HTTPMediaType(type: "application", subType: "vnd.stardivision.math"),
        case sdw // "sdw": HTTPMediaType(type: "application", subType: "vnd.stardivision.writer"),
        case sgl // "sgl": HTTPMediaType(type: "application", subType: "vnd.stardivision.writer-global"),
        case sxc // "sxc": HTTPMediaType(type: "application", subType: "vnd.sun.xml.calc"),
        case stc // "stc": HTTPMediaType(type: "application", subType: "vnd.sun.xml.calc.template"),
        case sxd // "sxd": HTTPMediaType(type: "application", subType: "vnd.sun.xml.draw"),
        case std // "std": HTTPMediaType(type: "application", subType: "vnd.sun.xml.draw.template"),
        case sxi // "sxi": HTTPMediaType(type: "application", subType: "vnd.sun.xml.impress"),
        case sti // "sti": HTTPMediaType(type: "application", subType: "vnd.sun.xml.impress.template"),
        case sxm // "sxm": HTTPMediaType(type: "application", subType: "vnd.sun.xml.math"),
        case sxw // "sxw": HTTPMediaType(type: "application", subType: "vnd.sun.xml.writer"),
        case sxg // "sxg": HTTPMediaType(type: "application", subType: "vnd.sun.xml.writer.global"),
        case stw // "stw": HTTPMediaType(type: "application", subType: "vnd.sun.xml.writer.template"),
        case sis // "sis": HTTPMediaType(type: "application", subType: "vnd.symbian.install"),
        case cap // "cap": HTTPMediaType(type: "application", subType: "vnd.tcpdump.pcap"),
        case pcap // "pcap": HTTPMediaType(type: "application", subType: "vnd.tcpdump.pcap"),
        case vsd // "vsd": HTTPMediaType(type: "application", subType: "vnd.visio"),
        case wbxml // "wbxml": HTTPMediaType(type: "application", subType: "vnd.wap.wbxml"),
        case wmlc // "wmlc": HTTPMediaType(type: "application", subType: "vnd.wap.wmlc"),
        case wmlsc // "wmlsc": HTTPMediaType(type: "application", subType: "vnd.wap.wmlscriptc"),
        case wpd // "wpd": HTTPMediaType(type: "application", subType: "vnd.wordperfect"),
        case wp5 // "wp5": HTTPMediaType(type: "application", subType: "vnd.wordperfect5.1"),
        case wasm // "wasm": HTTPMediaType(type: "application", subType: "wasm"),
        case wk // "wk": HTTPMediaType(type: "application", subType: "x-123"),
        case _7z = "7z" // "7z": HTTPMediaType(type: "application", subType: "x-7z-compressed"),
        case abw // "abw": HTTPMediaType(type: "application", subType: "x-abiword"),
        case dmg // "dmg": HTTPMediaType(type: "application", subType: "x-apple-diskimage"),
        case bcpio // "bcpio": HTTPMediaType(type: "application", subType: "x-bcpio"),
        case torrent // "torrent": HTTPMediaType(type: "application", subType: "x-bittorrent"),
        case cab // "cab": HTTPMediaType(type: "application", subType: "x-cab"),
        case cbr // "cbr": HTTPMediaType(type: "application", subType: "x-cbr"),
        case cbz // "cbz": HTTPMediaType(type: "application", subType: "x-cbz"),
        case cdf // "cdf": HTTPMediaType(type: "application", subType: "x-cdf"),
        case cda // "cda": HTTPMediaType(type: "application", subType: "x-cdf"),
        case vcd // "vcd": HTTPMediaType(type: "application", subType: "x-cdlink"),
        case pgn // "pgn": HTTPMediaType(type: "application", subType: "x-chess-pgn"),
        case mph // "mph": HTTPMediaType(type: "application", subType: "x-comsol"),
        case cpio // "cpio": HTTPMediaType(type: "application", subType: "x-cpio"),
        case csh // "csh": HTTPMediaType(type: "application", subType: "x-csh"),
        case deb // "deb": HTTPMediaType(type: "application", subType: "x-debian-package"),
        case udeb // "udeb": HTTPMediaType(type: "application", subType: "x-debian-package"),
        case dcr // "dcr": HTTPMediaType(type: "application", subType: "x-director"),
        case dir // "dir": HTTPMediaType(type: "application", subType: "x-director"),
        case dxr // "dxr": HTTPMediaType(type: "application", subType: "x-director"),
        case dms // "dms": HTTPMediaType(type: "application", subType: "x-dms"),
        case wad // "wad": HTTPMediaType(type: "application", subType: "x-doom"),
        case dvi // "dvi": HTTPMediaType(type: "application", subType: "x-dvi"),
        case pfa // "pfa": HTTPMediaType(type: "application", subType: "x-font"),
        case pfb // "pfb": HTTPMediaType(type: "application", subType: "x-font"),
        case gsf // "gsf": HTTPMediaType(type: "application", subType: "x-font"),
        case pcf // "pcf": HTTPMediaType(type: "application", subType: "x-font"),
        case _pcfZ = "pcf.Z" // "pcf.Z": HTTPMediaType(type: "application", subType: "x-font"),
        case woff // "woff": HTTPMediaType(type: "application", subType: "x-font-woff"),
        case mm // "mm": HTTPMediaType(type: "application", subType: "x-freemind"),
        case gan // "gan": HTTPMediaType(type: "application", subType: "x-ganttproject"),
        case gnumeric // "gnumeric": HTTPMediaType(type: "application", subType: "x-gnumeric"),
        case sgf // "sgf": HTTPMediaType(type: "application", subType: "x-go-sgf"),
        case gcf // "gcf": HTTPMediaType(type: "application", subType: "x-graphing-calculator"),
        case gtar // "gtar": HTTPMediaType(type: "application", subType: "x-gtar"),
        case tgz // "tgz": HTTPMediaType(type: "application", subType: "x-gtar-compressed"),
        case taz // "taz": HTTPMediaType(type: "application", subType: "x-gtar-compressed"),
        case hdf // "hdf": HTTPMediaType(type: "application", subType: "x-hdf"),
        case hwp // "hwp": HTTPMediaType(type: "application", subType: "x-hwp"),
        case ica // "ica": HTTPMediaType(type: "application", subType: "x-ica"),
        case info // "info": HTTPMediaType(type: "application", subType: "x-info"),
        case ins // "ins": HTTPMediaType(type: "application", subType: "x-internet-signup"),
        case isp // "isp": HTTPMediaType(type: "application", subType: "x-internet-signup"),
        case iii // "iii": HTTPMediaType(type: "application", subType: "x-iphone"),
        case iso // "iso": HTTPMediaType(type: "application", subType: "x-iso9660-image"),
        case jam // "jam": HTTPMediaType(type: "application", subType: "x-jam"),
        case jnlp // "jnlp": HTTPMediaType(type: "application", subType: "x-java-jnlp-file"),
        case jmz // "jmz": HTTPMediaType(type: "application", subType: "x-jmol"),
        case chrt // "chrt": HTTPMediaType(type: "application", subType: "x-kchart"),
        case kil // "kil": HTTPMediaType(type: "application", subType: "x-killustrator"),
        case skp // "skp": HTTPMediaType(type: "application", subType: "x-koan"),
        case skd // "skd": HTTPMediaType(type: "application", subType: "x-koan"),
        case skt // "skt": HTTPMediaType(type: "application", subType: "x-koan"),
        case skm // "skm": HTTPMediaType(type: "application", subType: "x-koan"),
        case kpr // "kpr": HTTPMediaType(type: "application", subType: "x-kpresenter"),
        case kpt // "kpt": HTTPMediaType(type: "application", subType: "x-kpresenter"),
        case ksp // "ksp": HTTPMediaType(type: "application", subType: "x-kspread"),
        case kwd // "kwd": HTTPMediaType(type: "application", subType: "x-kword"),
        case kwt // "kwt": HTTPMediaType(type: "application", subType: "x-kword"),
        case latex // "latex": HTTPMediaType(type: "application", subType: "x-latex"),
        case lha // "lha": HTTPMediaType(type: "application", subType: "x-lha"),
        case lyx // "lyx": HTTPMediaType(type: "application", subType: "x-lyx"),
        case lzh // "lzh": HTTPMediaType(type: "application", subType: "x-lzh"),
        case lzx // "lzx": HTTPMediaType(type: "application", subType: "x-lzx"),
        case frm // "frm": HTTPMediaType(type: "application", subType: "x-maker"),
        case maker // "maker": HTTPMediaType(type: "application", subType: "x-maker"),
        case frame // "frame": HTTPMediaType(type: "application", subType: "x-maker"),
        case fm // "fm": HTTPMediaType(type: "application", subType: "x-maker"),
        case fb // "fb": HTTPMediaType(type: "application", subType: "x-maker"),
        case book // "book": HTTPMediaType(type: "application", subType: "x-maker"),
        case fbdoc // "fbdoc": HTTPMediaType(type: "application", subType: "x-maker"),
        case md5 // "md5": HTTPMediaType(type: "application", subType: "x-md5"),
        case mif // "mif": HTTPMediaType(type: "application", subType: "x-mif"),
        case m3u8 // "m3u8": HTTPMediaType(type: "application", subType: "x-mpegURL"),
        case wmd // "wmd": HTTPMediaType(type: "application", subType: "x-ms-wmd"),
        case wmz // "wmz": HTTPMediaType(type: "application", subType: "x-ms-wmz"),
        case com // "com": HTTPMediaType(type: "application", subType: "x-msdos-program"),
        case exe // "exe": HTTPMediaType(type: "application", subType: "x-msdos-program"),
        case bat // "bat": HTTPMediaType(type: "application", subType: "x-msdos-program"),
        case dll // "dll": HTTPMediaType(type: "application", subType: "x-msdos-program"),
        case msi // "msi": HTTPMediaType(type: "application", subType: "x-msi"),
        case nc // "nc": HTTPMediaType(type: "application", subType: "x-netcdf"),
        case pac // "pac": HTTPMediaType(type: "application", subType: "x-ns-proxy-autoconfig"),
        case dat // "dat": HTTPMediaType(type: "application", subType: "x-ns-proxy-autoconfig"),
        case nwc // "nwc": HTTPMediaType(type: "application", subType: "x-nwc"),
        case o // "o": HTTPMediaType(type: "application", subType: "x-object"),
        case oza // "oza": HTTPMediaType(type: "application", subType: "x-oz-application"),
        case p7r // "p7r": HTTPMediaType(type: "application", subType: "x-pkcs7-certreqresp"),
        case crl // "crl": HTTPMediaType(type: "application", subType: "x-pkcs7-crl"),
        case pyc // "pyc": HTTPMediaType(type: "application", subType: "x-python-code"),
        case pyo // "pyo": HTTPMediaType(type: "application", subType: "x-python-code"),
        case qgs // "qgs": HTTPMediaType(type: "application", subType: "x-qgis"),
        case shp // "shp": HTTPMediaType(type: "application", subType: "x-qgis"),
        case shx
        case qtl
        case rdp
        case rpm
        case rss
        case rb
        case sci
        case sce
        case xcos
        case sh
        case sha1
        case shar
        case swf
        case swfl
        case scr
        case sql
        case sit
        case sitx
        case sv4cpio
        case sv4crc
        case tar
        case tcl
        case gf
        case pk
        case texinfo
        case texi
        case _tilde = "~"
        case _percent = "%"
        case bak
        case old
        case sik
        case t
        case tr
        case roff
        case man
        case me
        case ms
        case ustar
        case src
        case wz
        case crt
        case xcf
        case fig
        case xpi
        case amr
        case awb
        case axa
        case au
        case snd
        case csd
        case orc
        case sco
        case flac
        case mid
        case midi
        case kar
        case mpga
        case mpega
        case mp2
        case mp3
        case m4a
        case m3u
        case oga
        case ogg
        case opus
        case spx
        case sid
        case aif
        case aiff
        case aifc
        case gsm
        case wma
        case wax
        case ra
        case rm
        case ram
        case pls
        case sd2
        case wav
        case alc
        case cac
        case cache
        case csf
        case cbin
        case cascii
        case ctab
        case cdx
        case cer
        case c3d
        case chm
        case cif
        case cmdf
        case cml
        case cpa
        case bsd
        case csml
        case csm
        case ctx
        case cxf
        case cef
        case emb
        case embl
        case spc
        case inp
        case gam
        case gamin
        case fch
        case fchk
        case cub
        case gau
        case gjc
        case gjf
        case gal
        case gcg
        case gen
        case hin
        case istr
        case ist
        case jdx
        case dx
        case kin
        case mcm
        case mmd
        case mmod
        case mol
        case rd
        case rxn
        case sd
        case tgf
        case mcif
        case mol2
        case b
        case gpt
        case mop
        case mopcrt
        case mpc
        case zmt
        case moo
        case mvb
        case asn
        case prt
        case ent
        case val
        case aso
        case pdb
        case ros
        case sw
        case vms
        case vmd
        case xtel
        case xyz
        case gif
        case ief
        case jp2
        case jpg2
        case jpeg
        case jpg
        case jpe
        case jpm
        case jpx
        case jpf
        case pcx
        case png
        case svg
        case svgz
        case tiff
        case tif
        case webp
        case djvu
        case djv
        case ico
        case wbmp
        case cr2
        case crw
        case ras
        case cdr
        case pat
        case cdt
        case erf
        case art
        case jng
        case bmp
        case nef
        case orf
        case psd
        case pnm
        case pbm
        case pgm
        case ppm
        case rgb
        case xbm
        case xpm
        case xwd
        case eml
        case igs
        case iges
        case msh
        case mesh
        case silo
        case wrl
        case vrml
        case x3dv
        case x3d
        case x3db
        case appcache
        case ics
        case icz
        case css
        case csv
        case _323 = "323"
        case html
        case htm
        case shtml
        case uls
        case mml // "mml": HTTPMediaType(type: "text", subType: "mathml"),
        case asc // "asc": HTTPMediaType(type: "text", subType: "plain"),
        case txt // "txt": HTTPMediaType(type: "text", subType: "plain"),
        case text // "text": HTTPMediaType(type: "text", subType: "plain"),
        case pot // "pot": HTTPMediaType(type: "text", subType: "plain"),
        case brf // "brf": HTTPMediaType(type: "text", subType: "plain"),
        case srt // "srt": HTTPMediaType(type: "text", subType: "plain"),
        case rtx // "rtx": HTTPMediaType(type: "text", subType: "richtext"),
        case sct // "sct": HTTPMediaType(type: "text", subType: "scriptlet"),
        case wsc // "wsc": HTTPMediaType(type: "text", subType: "scriptlet"),
        case tm // "tm": HTTPMediaType(type: "text", subType: "texmacs"),
        case tsv // "tsv": HTTPMediaType(type: "text", subType: "tab-separated-values"),
        case ttl // "ttl": HTTPMediaType(type: "text", subType: "turtle"),
        case jad // "jad": HTTPMediaType(type: "text", subType: "vnd.sun.j2me.app-descriptor"),
        case wml // "wml": HTTPMediaType(type: "text", subType: "vnd.wap.wml"),
        case wmls // "wmls": HTTPMediaType(type: "text", subType: "vnd.wap.wmlscript"),
        case bib // "bib": HTTPMediaType(type: "text", subType: "x-bibtex"),
        case boo // "boo": HTTPMediaType(type: "text", subType: "x-boo"),
        case _h_plusplus = "h++" // "h++": HTTPMediaType(type: "text", subType: "x-c++hdr"),
        case hpp // "hpp": HTTPMediaType(type: "text", subType: "x-c++hdr"),
        case hxx // "hxx": HTTPMediaType(type: "text", subType: "x-c++hdr"),
        case hh // "hh": HTTPMediaType(type: "text", subType: "x-c++hdr"),
        case _c_plusplus = "c++" // "c++": HTTPMediaType(type: "text", subType: "x-c++src"),
        case cpp // "cpp": HTTPMediaType(type: "text", subType: "x-c++src"),
        case cxx // "cxx": HTTPMediaType(type: "text", subType: "x-c++src"),
        case cc // "cc": HTTPMediaType(type: "text", subType: "x-c++src"),
        case h // "h": HTTPMediaType(type: "text", subType: "x-chdr"),
        case htc // "htc": HTTPMediaType(type: "text", subType: "x-component"),
        case c // "c": HTTPMediaType(type: "text", subType: "x-csrc"),
        case d // "d": HTTPMediaType(type: "text", subType: "x-dsrc"),
        case diff // "diff": HTTPMediaType(type: "text", subType: "x-diff"),
        case patch // "patch": HTTPMediaType(type: "text", subType: "x-diff"),
        case hs // "hs": HTTPMediaType(type: "text", subType: "x-haskell"),
        case java // "java": HTTPMediaType(type: "text", subType: "x-java"),
        case ly // "ly": HTTPMediaType(type: "text", subType: "x-lilypond"),
        case lhs // "lhs": HTTPMediaType(type: "text", subType: "x-literate-haskell"),
        case moc // "moc": HTTPMediaType(type: "text", subType: "x-moc"),
        case p // "p": HTTPMediaType(type: "text", subType: "x-pascal"),
        case pas // "pas": HTTPMediaType(type: "text", subType: "x-pascal"),
        case gcd // "gcd": HTTPMediaType(type: "text", subType: "x-pcs-gcd"),
        case pl // "pl": HTTPMediaType(type: "text", subType: "x-perl"),
        case pm // "pm": HTTPMediaType(type: "text", subType: "x-perl"),
        case py // "py": HTTPMediaType(type: "text", subType: "x-python"),
        case scala // "scala": HTTPMediaType(type: "text", subType: "x-scala"),
        case etx // "etx": HTTPMediaType(type: "text", subType: "x-setext"),
        case sfv // "sfv": HTTPMediaType(type: "text", subType: "x-sfv"),
        case tk // "tk": HTTPMediaType(type: "text", subType: "x-tcl"),
        case tex // "tex": HTTPMediaType(type: "text", subType: "x-tex"),
        case ltx // "ltx": HTTPMediaType(type: "text", subType: "x-tex"),
        case sty // "sty": HTTPMediaType(type: "text", subType: "x-tex"),
        case cls // "cls": HTTPMediaType(type: "text", subType: "x-tex"),
        case vcs // "vcs": HTTPMediaType(type: "text", subType: "x-vcalendar"),
        case vcf // "vcf": HTTPMediaType(type: "text", subType: "x-vcard"),
        case _3gp = "3gp" // "3gp": HTTPMediaType(type: "video", subType: "3gpp"),
        case axv // "axv": HTTPMediaType(type: "video", subType: "annodex"),
        case dl // "dl": HTTPMediaType(type: "video", subType: "dl"),
        case dif // "dif": HTTPMediaType(type: "video", subType: "dv"),
        case dv // "dv": HTTPMediaType(type: "video", subType: "dv"),
        case fli // "fli": HTTPMediaType(type: "video", subType: "fli"),
        case gl // "gl": HTTPMediaType(type: "video", subType: "gl"),
        case mpeg // "mpeg": HTTPMediaType(type: "video", subType: "mpeg"),
        case mpg // "mpg": HTTPMediaType(type: "video", subType: "mpeg"),
        case mpe // "mpe": HTTPMediaType(type: "video", subType: "mpeg"),
        case ts // "ts": HTTPMediaType(type: "video", subType: "MP2T"),
        case mp4 // "mp4": HTTPMediaType(type: "video", subType: "mp4"),
        case qt // "qt": HTTPMediaType(type: "video", subType: "quicktime"),
        case mov // "mov": HTTPMediaType(type: "video", subType: "quicktime"),
        case ogv // "ogv": HTTPMediaType(type: "video", subType: "ogg"),
        case webm // "webm": HTTPMediaType(type: "video", subType: "webm"),
        case mxu // "mxu": HTTPMediaType(type: "video", subType: "vnd.mpegurl"),
        case flv // "flv": HTTPMediaType(type: "video", subType: "x-flv"),
        case lsf // "lsf": HTTPMediaType(type: "video", subType: "x-la-asf"),
        case lsx // "lsx": HTTPMediaType(type: "video", subType: "x-la-asf"),
        case mng // "mng": HTTPMediaType(type: "video", subType: "x-mng"),
        case asf // "asf": HTTPMediaType(type: "video", subType: "x-ms-asf"),
        case asx // "asx": HTTPMediaType(type: "video", subType: "x-ms-asf"),
        case wm // "wm": HTTPMediaType(type: "video", subType: "x-ms-wm"),
        case wmv // "wmv": HTTPMediaType(type: "video", subType: "x-ms-wmv"),
        case wmx // "wmx": HTTPMediaType(type: "video", subType: "x-ms-wmx"),
        case wvx // "wvx": HTTPMediaType(type: "video", subType: "x-ms-wvx"),
        case avi // "avi": HTTPMediaType(type: "video", subType: "x-msvideo"),
        case movie // "movie": HTTPMediaType(type: "video", subType: "x-sgi-movie"),
        case mpv // "mpv": HTTPMediaType(type: "video", subType: "x-matroska"),
        case mkv // "mkv": HTTPMediaType(type: "video", subType: "x-matroska"),
        case ice // "ice": HTTPMediaType(type: "x-conference", subType: "x-cooltalk"),
        case sisx // "sisx": HTTPMediaType(type: "x-epoc", subType: "x-sisx-app"),
        case vrm // "vrm": HTTPMediaType(type: "x-world", subType: "x-vrml"),
    }
}
