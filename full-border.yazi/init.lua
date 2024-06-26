local function setup()
	Manager.render = function(self, area)
		local chunks = self:layout(area)

		local dynamic_first_bar = function()
			if chunks[2].w == 0 then
				return
			end

			return ui.Bar(chunks[1], ui.Bar.RIGHT)
		end

		local bar = function(c, x, y)
			x, y = math.max(0, x), math.max(0, y)

			return ui.Bar(
				ui.Rect { x = x, y = y, w = ya.clamp(0, area.w - x, 1), h = math.min(1, area.h) },
				x == 0 and ui.Bar.NONE or ui.Bar.TOP
			):symbol(c)
		end

		local dynamic_padding = function()
			if chunks[1].w == 0 then
				return ui.Padding(1, 0, 1, 1)
			elseif chunks[3].w == 0 then
				return ui.Padding(0, 1, 1, 1)
			end

			return ui.Padding.y(1)
		end

		return ya.flat {
			-- Borders
			ui.Border(area, ui.Border.ALL):type(ui.Border.ROUNDED),
			dynamic_first_bar(),
			ui.Bar(chunks[3], ui.Bar.LEFT),

			bar("┬", chunks[1].right - 1, chunks[1].y),
			bar("┴", chunks[1].right - 1, chunks[1].bottom - 1),
			bar("┬", chunks[2].right, chunks[2].y),
			bar("┴", chunks[2].right, chunks[1].bottom - 1),

			-- Parent
			Parent:render(chunks[1]:padding(ui.Padding.xy(1))),
			-- Current
			Current:render(chunks[2]:padding(dynamic_padding())),
			-- Preview
			Preview:render(chunks[3]:padding(ui.Padding.xy(1))),
		}
	end
end

return { setup = setup }
