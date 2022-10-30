# simple example of csv parsing

lappend auto_path [file join tcllib modules csv]
lappend auto_path [file join tcllib modules struct]

package require csv
package require struct::matrix

proc catNameToId {catName} {
  set catId 0

  if {$catName eq {Бытовая техника}} {
    set catId 2
  }

  return $catId
}

proc subCatNameToId {catName} {
  set catId 0

  if {$catName eq {Вентиляторы}} {
    set catId 212
  } elseif {$catName eq {Вытяжки}} {
    set catId 206
  }  elseif {$catName eq {Мелкая кухонная техника}} {
    set catId 217
  } elseif {$catName eq {Микроволновые печи}} {
    set catId 216
  } elseif {$catName eq {Обогреватели}} {
    set catId 1105
  } elseif {$catName eq {Очистители воздуха}} {
    set catId 212
  } elseif {$catName eq {Плиты}} {
    set catId 203
  } elseif {$catName eq {Посудомоечные машины}} {
    set catId 205
  } elseif {$catName eq {Пылесосы}} {
    set catId 209
  } elseif {$catName eq {Стиральные машины}} {
    set catId 208
  } elseif {$catName eq {Утюги}} {
    set catId 211
  } elseif {$catName eq {Холодильники и морозильные камеры}} {
    set catId 202
  } elseif {$catName eq {Фены и приборы для укладки}} {
    set catId 1407
  }

  return $catId
}

proc splitPics {pics} {
  return [split $pics |]
}

proc formatDesc {desc} {
  set result [string map {<p><strong> {} </strong></p> {}} $desc]
  set result [join [list {<![CDATA[} $result {]]>}] {}]

  return $result
}

set outFile [open output.yml w]
set formattedDate [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]

puts $outFile {<?xml version="1.0" encoding="UTF-8"?>}
puts $outFile "<yml_catalog date=\"$formattedDate\">"
puts $outFile {  <shop>}
puts $outFile {    <offers>}

set inFile [open input.csv]
struct::matrix data

csv::read2matrix $inFile data , auto

close $inFile

set rows [data rows]

for {set row 1} {$row < $rows} {incr row} {
    set offerId [data get cell 0 $row]
    set offerUrl {}
    set offerCatId [catNameToId [data get cell 1 $row]]
    set offerSubCatId [subCatNameToId [data get cell 14 $row]]
    set offerAddress [data get cell 2 $row]
    set offerPrice [data get cell 8 $row]
    set offerPhone [data get cell 12 $row]
    set offerName [data get cell 6 $row]
    set offerPics [splitPics [data get cell 10 $row]]
    set offerDesc [formatDesc [data get cell 5 $row]]
    set offerManagerName [data get cell 9 $row]

    puts $outFile "      <offer id=\"$offerId\">"

    if {$offerUrl ne {}} {
      puts $outFile "      <url>$offerUrl</url>"
    }

    puts $outFile "        <youlaCategoryId>$offerCatId</youlaCategoryId>"
    puts $outFile "        <youlaSubcategoryId>$offerSubCatId</youlaSubcategoryId>"
    puts $outFile "        <address>$offerAddress</address>"
    puts $outFile "        <price>$offerPrice</price>"
    puts $outFile "        <phone>$offerPhone</phone>"
    puts $outFile "        <name>$offerName</name>"

    foreach {offerPic} $offerPics {
      puts $outFile "        <picture>$offerPic</picture>"
    }

    puts $outFile "        <description>$offerDesc</description>"
    puts $outFile "        <managerName>$offerManagerName</managerName>"
    puts $outFile {      </offer>}
}

puts $outFile {    </offers>}
puts $outFile {  </shop>}
puts $outFile </yml_catalog>

close $outFile
