p = instance_create_depth(120, 120, 100, obj_player);
wall = instance_create_depth(140, 80, 300, obj_colisor);
wall.image_yscale = 5;
cases = [[ord("W")],[ord("S")],[ord("A")],[ord("D")],[vk_up],[vk_down],[vk_left],[vk_right],[ord("W"),vk_right],[ord("W"),vk_up],[ord("W"),vk_down],[ord("A"),vk_right],[vk_right],[ord("D")],[vk_right]];
dx = [0,0,-1,1,0,0,-1,1];
dy = [-1,1,0,0,-1,1,0,0];
case_index = 0;
tick = 0;
