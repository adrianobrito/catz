require "curses"
include Curses

module View

	class TerminalWindow
		SCREEN_HEIGHT      = 14
		SCREEN_WIDTH       = 80
		HEADER_HEIGHT      = 1
		HEADER_WIDTH       = SCREEN_WIDTH
		MAIN_WINDOW_HEIGHT = SCREEN_HEIGHT - HEADER_HEIGHT
		MAIN_WINDOW_WIDTH  = SCREEN_WIDTH

		def render
			# init_screen
			# begin
			#   crmode
			# #  show_message("Hit any key")
			#   setpos((lines - 5) / 2, (cols - 10) / 2)
			#   addstr("Hit any key")
			#   refresh
			#   getch
			#   show_message("Hello, World!")
			#   refresh
			# ensure
			#   close_screen
			# end	
			init		
			show_header
			show_editor
			#getch
		end

		def show_message(message)
		  width = message.length + 6
		  win = Window.new(5, width,
		            (lines - 5) / 2, (cols - width) / 2)
		  win.box(?|, ?-)
		  win.setpos(2, 3)
		  win.addstr(message)
		  win.refresh
		  win.getch
		  win.close
		end

		private 
			def init
				noecho
				nonl
				stdscr.keypad(true)
				raw
				stdscr.nodelay = 1
				start_color
				init_pair(2, COLOR_BLACK, COLOR_WHITE)
				init_pair(3, COLOR_BLACK, COLOR_WHITE)

				init_screen
				crmode
				init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK)
			end

			def show_header
				header_window = Curses::Window.new(HEADER_HEIGHT, HEADER_WIDTH, 0, 0)
				header_window.color_set(2)
				header_window << "Catz".center(HEADER_WIDTH)
				header_window.refresh
			end

			def show_editor
				editor = Curses::Window.new(24, SCREEN_WIDTH, 1, 0)
				editor.idlok(true)
				editor.scrollok(true)
				editor.setpos(0, 0)
				editor.keypad(true)

				init_editor(editor)

				editor.refresh
				editor
			end

			def init_editor(editor)
				loop do
					input = editor.getch
					case input
					when 13 #Enter
						editor.addstr "\n"
						editor.move(1,0)
					when 8
						editor.delch
						editor.move(-1,0)
					else
						editor.addstr(input.to_s)	if input
					end
				end
			end

	end

end