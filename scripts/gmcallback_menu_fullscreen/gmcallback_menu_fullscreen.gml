// This name is preserved by the HTML5 exporter for the official clickable API.
function gmcallback_menu_fullscreen(_action, _full, _width, _height, _density)
{
    if (os_browser == browser_not_a_browser) return false;
    var _menu = instance_find(obj_main_menu, 0);
    if (_action == "ready")
    {
        if (room != rm_menu || !instance_exists(_menu)) return false;
        return variable_instance_exists(_menu, "menu_update_web_button");
    }
    if (_action == "can_toggle")
    {
        if (room != rm_menu || !instance_exists(_menu)) return false;
        if (_menu.show_controls) return false;
        _menu.menu_selected = 2;
        _menu.activate_option = false;
        som_efeito("select");
        return true;
    }
    if (_action == "changed")
    {
        if (_width > 0 && _height > 0) window_set_size(_width, _height);
        global.menu_browser_fullscreen = _full;
        global.menu_browser_pixel_width = _width;
        global.menu_browser_pixel_height = _height;
        global.menu_browser_density = max(1, _density);
        if (instance_exists(_menu))
        {
            _menu.menu_browser_fullscreen = _full;
            _menu.menu_browser_density = global.menu_browser_density;
        }
        return true;
    }
    return false;
}

function ui_mouse_x_to_gui(_device)
{
    var _raw = device_mouse_x_to_gui(_device);
    var _density = ui_mouse_density();
    if (_density == 1) return _raw;
    var _surface = application_get_position();
    return ui_pointer_correct(_raw, _density, _surface[0], _surface[2] - _surface[0], display_get_gui_width());
}

function ui_mouse_y_to_gui(_device)
{
    var _raw = device_mouse_y_to_gui(_device);
    var _density = ui_mouse_density();
    if (_density == 1) return _raw;
    var _surface = application_get_position();
    return ui_pointer_correct(_raw, _density, _surface[1], _surface[3] - _surface[1], display_get_gui_height());
}

function ui_mouse_density()
{
    if (os_browser == browser_not_a_browser) return 1;
    if (!variable_global_exists("menu_browser_density")) return 1;
    return max(1, global.menu_browser_density);
}

function ui_pointer_correct(_raw, _density, _surface_origin, _surface_span, _gui_span)
{
    // HTML5 input is measured in CSS pixels, but device_mouse_*_to_gui subtracts
    // the physical application-surface origin and divides by its physical size.
    // Undo the CSS scale without multiplying that physical offset a second time.
    return _raw * _density + (_density - 1) * _surface_origin * _gui_span / max(1, _surface_span);
}
