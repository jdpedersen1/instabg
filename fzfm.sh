#!/usr/bin/env bash


fzfm () {
    while true; do
        selection="$(lsd -a -1 | fzf \
            --bind "left:pos(2)+accept" \
            --bind "right:accept" \
            --bind "shift-up:preview-up" \
            --bind "shift-down:preview-down" \
            --bind "ctrl-d:execute(bash -e ~/.local/fzfm/create_dir.sh)" \
            --bind "ctrl-f:execute(bash -e ~/.local/fzfm/create_file.sh)" \
            --bind "ctrl-t:execute(bash -e ~/.local/fzfm/delete_selected.sh {})" \
            --bind "space:toggle" \
            --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#121212,bg+:#262626 \
            --color=hl:#5f87af,hl+:#487caf,info:#afaf87,marker:#274a37 \
            --color=pointer:#a62b2b,spinner:#af5fff,prompt:#876253,header:#87afaf \
            --height 95% \
            --pointer  \
            --reverse \
            --multi \
            --info right \
            --prompt "Search: " \
            --border "bold" \
            --border-label "$(pwd)/" \
            --preview-window=right:65% \
            --preview 'cd_pre="$(echo $(pwd)/$(echo {}))";
                    echo "Folder: " $cd_pre;
                    lsd -a --color=always "${cd_pre}";
                    cur_file="$(file {} | grep [Tt]ext | wc -l)";
                    if [[ "${cur_file}" -eq 1 ]]; then
                        bat --style=numbers --theme=ansi --color=always {} 2>/dev/null
                    else
                        chafa -c full --color-space rgb --dither none -p on -w 9 2>/dev/null {}
                        fi')"
                        file_type=$(file -b --mime-type "${selection}" | cut -d'/' -f1)
                        case $file_type in
                            "text")
                                vim "${selection}"
                                ;;
                            "image")
                                for fType in ${selection}
                                do
                                    if [[ "${fType}" == *.xcf ]]; then
                                        gimp 2>/dev/null "${selection}"
                                    else
                                        sxiv "${selection}"
                                    fi
                                done
                                ;;
                            "video")
                                mpv -fs "${selection}" > /dev/null
                                ;;
                            "inode")
                                cd "${selection}" > /dev/null
                                ;;
                            "application")
                                for fType in ${selection}
                                do
                                    if [[ "${fType}" == *.docx ]] || [[ "${fType}" == *.odt ]]; then
                                        libreoffice "${selection}" > /dev/null
                                    elif [[ "${fType}" == *.pdf ]]; then
                                        zathura 2>/dev/null "${selection}"
                                    fi
                                done
                                ;;
                            *)
                                break
                                ;;
                        esac        done
                    }

                    clear
                    fzfm

