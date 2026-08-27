switch (enemy_state)
{
	case 0:
	{
		if (instance_exists(obj_player))
		{
			var _jogador_encontrado = noone;

			switch (dir)
			{
			    case 0:
			        _jogador_encontrado = collision_rectangle(x,  y - vision_width,  x + vision_distance,  y + vision_width, obj_player,  false,  true);
			        break;
					
				case 1:
			        _jogador_encontrado = collision_rectangle(x - vision_width,  y - vision_distance,  x + vision_width,  y, obj_player, false, true);
			        break;
					
			    case 2:
			        _jogador_encontrado = collision_rectangle( x - vision_distance,  y - vision_width, x,  y + vision_width,  obj_player, false, true);
			        break;
					
			    case 3:
			        _jogador_encontrado = collision_rectangle(x - vision_width,  y, x + vision_width,  y + vision_distance,  obj_player, false,  true);
			        break;
			}
			
			var _viu_jogador = _jogador_encontrado != noone;
			
			var _caminho_livre = collision_line(x,y, obj_player.x, obj_player.y, obj_colisor, false, true) == noone;
			if(_viu_jogador && _caminho_livre)
			{
				target_player = _jogador_encontrado;
				target_player.movimento_liberado = false;
				
				enemy_state = 1;
				
				show_debug_message("O slime viu o jogador!");
			}
		}
		break;
	}
	case 1:
	{
		if (instance_exists(target_player))
		{
			var _distancia = point_distance(x,y, target_player.x, target_player.y);
			if (_distancia > stop_distance)
			{
				var _hor = target_player.x - x;
				var _ver = target_player.y - y;
				
				_hor /= _distancia;
				_ver /= _distancia;
				
				move_and_collide(_hor * move_speed, _ver * move_speed, obj_colisor);
			}
			else
			{
				enemy_state = 2; 
				
				show_debug_message("Iniciar diálogo e batalha!");
			}	
		}
		break;
	}
	case 2:
	{
		break;
	}	
}	