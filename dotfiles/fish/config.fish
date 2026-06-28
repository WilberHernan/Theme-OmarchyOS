source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting - neofetch with Barroco ASCII
function fish_greeting
    neofetch --ascii ~/.config/neofetch/barroco.txt
end
