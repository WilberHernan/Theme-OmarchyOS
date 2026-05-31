source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting - neofetch with Tengu Mask
function fish_greeting
    neofetch --ascii ~/.config/neofetch/tengu_mask.txt
end
