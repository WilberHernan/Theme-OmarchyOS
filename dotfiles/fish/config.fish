source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting - neofetch specs only (no logo)
function fish_greeting
    neofetch --off
end
