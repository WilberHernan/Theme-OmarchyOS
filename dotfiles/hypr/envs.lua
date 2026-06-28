
-- NVIDIA (Turing+ with GSP firmware)
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Cursor theme (Bibata solo tiene XCursor, no hyprcursor)
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "20")
hl.config({ cursor = { no_hardware_cursors = true } })
