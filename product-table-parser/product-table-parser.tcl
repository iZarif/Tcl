# simple example of json parsing in Tcl

lappend auto_path [file join tcllib modules json]

package require json

set itemsPerFile 10
set filesNum 1
set outFile [open output.csv w]

for {set fileNum 0} {$fileNum < $filesNum} {incr fileNum} {
  set inFile [open input$fileNum.json]
  set data [read $inFile]

  close $inFile

  set parsedData [json::json2dict $data]
  set parsedData [dict get $parsedData data]

  for {set itemNum 0} {$itemNum < $itemsPerFile} {incr itemNum} {
    set item [lindex $parsedData $itemNum]
    set itemTitle [dict get $item title]
    set itemProtein [dict get $item protein]
    set itemFat [dict get $item fat]
    set itemCarbohydrate [dict get $item carbohydrate]
    set itemFiber [dict get $item fiber]

    puts $outFile $itemTitle,$itemProtein,$itemFat,$itemCarbohydrate,$itemFiber
  }
}

close $outFile
