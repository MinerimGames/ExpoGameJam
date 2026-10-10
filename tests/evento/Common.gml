failures = 0;
// Native mixer remains active for integration checks without audible test runs.
audio_master_gain(0);
checks = 0;
#macro keyboard_key_press global.evento_test_key_press
#macro keyboard_key_release global.evento_test_key_release
#macro keyboard_check global.evento_test_key_down
#macro keyboard_check_pressed global.evento_test_key_pressed
#macro keyboard_check_released global.evento_test_key_released
global.evento_keys=array_create(256,false);
global.evento_pressed=array_create(256,false);
global.evento_released=array_create(256,false);
function evento_test_input_begin()
{
    global.evento_pressed=array_create(256,false);
    global.evento_released=array_create(256,false);
}
global.evento_test_key_press=function(_key)
{
    if(!global.evento_keys[_key])global.evento_pressed[_key]=true;
    global.evento_keys[_key]=true;
}
global.evento_test_key_release=function(_key)
{
    if(global.evento_keys[_key])global.evento_released[_key]=true;
    global.evento_keys[_key]=false;
}
global.evento_test_key_down=function(_key){return global.evento_keys[_key];}
global.evento_test_key_pressed=function(_key){return global.evento_pressed[_key];}
global.evento_test_key_released=function(_key){return global.evento_released[_key];}
check = function(_ok, _name) {
    checks += 1;
    if (!_ok) { failures += 1; show_debug_message("EVENTO_TEST_FAIL: " + _name); }
};
finish_tests = function() {
    show_debug_message((failures == 0 ? "EVENTO_TEST_PASS: " : "EVENTO_TEST_FAIL: ") + string(checks) + " checks, " + string(failures) + " failures");
    game_end();
};
clear_keys = function() {
    var _keys = [ord("W"), ord("S"), ord("A"), ord("D"), vk_up, vk_down, vk_left, vk_right];
    for (var _i = 0; _i < array_length(_keys); _i++) keyboard_key_release(_keys[_i]);
};
