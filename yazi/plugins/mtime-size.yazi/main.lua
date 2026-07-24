local M = {}

local function setup(_, opts)
	opts = opts or {}

	Linemode:children_add(function(self)
		if not self._file.in_current then
			return ""
		end

		local cha = self._file.cha

		-- Size
		local len = cha.len or 0
		local size_str
		if cha.is_dir then
			size_str = "    -"
		elseif len >= 1073741824 then
			size_str = string.format("%4.1fG", len / 1073741824)
		elseif len >= 1048576 then
			size_str = string.format("%4.1fM", len / 1048576)
		elseif len >= 1024 then
			size_str = string.format("%4.1fK", len / 1024)
		else
			size_str = string.format("%4dB", len)
		end

		-- Mtime
		local mtime = cha.mtime
		local time_str = mtime and os.date("%m/%d %H:%M", mtime) or "--/-- --:--"

		return ui.Line(string.format(" %s  %s", size_str, time_str))
	end, opts.order or 2000)
end

M.setup = setup
return M
