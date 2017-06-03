alias Converge.Util
alias Gears.StringUtil

defmodule RoleNvidia do
	require Util
	Util.declare_external_resources("files")

	def role(_tags \\ []) do
		version = get_current_official_release()
		desired_packages = [
			"nvidia-#{version}",
			"libcuda1-#{version}",
			"nvidia-opencl-icd-#{version}",
			"nvidia-settings",
		]
		%{
			desired_packages: desired_packages,
			apt_keys:         [Util.content("files/apt_keys/1118213C Launchpad PPA for Graphics Drivers Team.txt")],
			apt_sources:      ["deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu xenial main"],
		}
	end

	def get_current_official_release() do
		# The PPA doesn't have a metapackage that points to the latest official or long-lived release,
		# so we have to extract the version from the page.
		{out, 0} = System.cmd("curl", ["-sL", "https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa"])
		line     = StringUtil.grep(out, ~r/^Current official release: `nvidia-\d+`/) |> hd
		version  = Regex.run(~r/nvidia-(\d+)/, line, capture: :all_but_first) |> hd |> String.to_integer
		version
	end
end
