alias Converge.Util

defmodule RoleNvidia do
	require Util
	Util.declare_external_resources("files")

	def role(_tags \\ []) do
		version = 378
		%{
			desired_packages: ["nvidia-#{version}", "libcuda1-#{version}", "nvidia-opencl-icd-#{version}", "nvidia-settings"],
			apt_keys:         [Util.content("files/apt_keys/1118213C Launchpad PPA for Graphics Drivers Team.txt")],
			apt_sources:      ["deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu xenial main"],
		}
	end
end
