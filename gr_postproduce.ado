cap program drop gr_postproduce 
program gr_postproduce, rclass

#delimit ;
syntax anything,
    [
        title(string)
        xtitle(string)
        ytitle(string)
        subtitle(string)
        note(string)
        caption(string)

        obj(string)

        leg_rename(string)
        leg_pos(string)
        saving(string)

    ]
;
#delimit cr

tokenize `anything'
foreach v in `anything' {
    qui {
        cap gr use "`v'.gph"
        if _rc != 0 {
            di as error "`v' is not a local graph or a graph in memory"
            exit 110
        }

        local nl = char(10)
        local bt = char(96)
        local sq = char(39)
        cap erase "grec_hid.grec"
        cap file close grec
        file open grec using "grec_hid.grec", write replace

        if length("`title'") != 0 {
            grec_write grec "gr_edit .title.text"  "`title'"
        }
        if length("`xtitle'") != 0 {
            grec_write grec "gr_edit .xaxis1.title.text" "`xtitle'"
        }
        if length("`ytitle'") != 0 {
            grec_write grec "gr_edit .yaxis1.title.text" "`ytitle'"
        }
        if length("`subtitle'") != 0 {
            grec_write grec "gr_edit .subtitle.text" "`subtitle'"
        }
        if length("`caption'") != 0 {
            grec_write grec "gr_edit .caption.text" "`caption'"
        }
        if length("`note'") != 0 {
            grec_write grec "gr_edit .note.text" "`note'"
        }

        if length("`obj'") != 0 {
            local objs = 0
            local obj = "`obj',"
            local go = 1
            while `go' == 1 {
                local j = strpos("`obj'", ",")
                {
                    if `j' != 0 {
                        local objs = `objs' + 1
                        local v_`objs' = strtrim(subinstr(subinstr(substr("`obj'", 1, `j'), "`objs' ", "", .), ",", "", .))
                        local obj = strtrim(subinstr("`obj'", substr("`obj'", 1, `j'), "", .))
                    }
                    else {
                        local go = 0
                    }
                }
            }
            forv i=1/`objs' {
                local go = 1
                local v_`i' = "`v_`i'' "
                while `go' == 1 {
                    local j = strpos("`v_`i''", " ")
                    {
                        if `j' > 1 {
                            local opt = substr("`v_`i''", 1, `j')
                            local opt = strtrim("`opt'")
                            local command = substr("`opt'", 1, strpos("`opt'", "(") - 1)
                            local par = substr("`opt'", strpos("`opt'", "(") + 1, .)
                            local par = subinstr("`par'", ")", "", .)

                            if inlist("`command'", "msiz", "msize") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle marker(size(`par')) editcopy `nl'"
                            } 
                            if inlist("`command'", "ms", "msy", "msym", "msymb", "msymbo", "msymbol") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle marker(symbol(`par')) editcopy `nl'"
                            } 
                            if inlist("`command'", "mc", "mco", "mcol", "mcolo", "mcolor") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle marker(fillcolor(`par')) editcopy `nl'"
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle marker(linestyle(color(`par'))) editcopy `nl'"
                            } 

                            if inlist("`command'", "lc", "lco", "lcol", "lcolo", "lcolor") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle line(color(`par')) editcopy `nl'"
                            } 
                            if inlist("`command'", "lp", "lpa", "lpat", "lpatt", "lpatte", "lpatter", "lpattern") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle line(pattern(`par')) editcopy `nl'"
                            } 
                            if inlist("`command'", "lw", "lwi", "lwid", "lwidt", "lwidth") {
                                file write grec "gr_edit .plotregion1.plot`i'.style.editstyle line(width(`par')) editcopy `nl'"
                            } 

                            local v_`i' = subinstr("`v_`i''", "`opt' ", "", .) 
                        }
                        else {
                            local go = 0
                        }
                    }
                }
            }
        }

        if length("`leg_rename'") != 0 {
            local legarg = 0
            local leg_rename = "`leg_rename',"
            local go = 1
            while `go' == 1 {
                local j = strpos("`leg_rename'", ",")
                {
                if `j' > 1 {
                    local legarg = `legarg' + 1
                    local leglab = substr("`leg_rename'", 1, `j')
                    local leg_rename = subinstr("`leg_rename'", "`leglab'", "", .)
                    local leglab = strtrim(subinstr("`leglab'", ",", "", .))
                    file write grec "gr_edit .legend.plotregion1.label[`legarg'].text = {} `nl'"
                    file write grec "gr_edit .legend.plotregion1.label[`legarg'].text.Arrpush `leglab' `nl'"
                }
                else {
                    local go = 0
                }
                }
            }

        }

        if length("`saving'") != 0 {
            file write grec "gr save `saving' `nl'"
        }
        file close grec

        do "grec_hid.grec"
    }
}
erase "grec_hid.grec"
end

cap program drop grec_write
program grec_write
syntax anything
tokenize `anything'
qui {
    local nl = char(10)
    local qt = char(34)
    file write `1' "`2' = {"
    file write `1' `"`=char(34)'"' 
    file write `1' "`3'"
    file write `1' `"`=char(34)'"' 
    file write `1' "} `nl'"
}
end





