# Arguments: bed, name, where
$data modify storage bed_tweaks:tmp menu append value {text:"[#$(bed) ",underlined:true,extra:[{translate:"$(name)"},{text:", $(where)]"}],click_event:{action:"run_command",command:"trigger bed_tweaks.pick set $(bed)"},hover_event:{action:"show_text",value:"Go to this bed"}}
