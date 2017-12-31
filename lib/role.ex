alias Converge.{Util, All}

defmodule RoleNvidia do
	require Util
	import Util, only: [conf_file: 1, conf_dir: 1]
	Util.declare_external_resources("files")

	def role(tags \\ []) do
		release = Util.tag_value!(tags, "release") |> String.to_atom()
		post_install_unit =
			%All{units: [
				conf_dir("/etc/X11"),
				conf_dir("/etc/X11/xorg.conf.d"),
				conf_file("/etc/X11/xorg.conf.d/90-nvidia_i2c.conf"),
			]}
		case release do
			:xenial ->
				version = 384
				%{
					desired_packages: [
						"nvidia-#{version}",
						"libcuda1-#{version}",
						"nvidia-libopencl1-#{version}",
						"nvidia-opencl-icd-#{version}",
						"nvidia-settings",
					],
					apt_keys:          [Util.content("files/apt_keys/1118213C Launchpad PPA for Graphics Drivers Team.gpg")],
					apt_sources:       ["deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu xenial main"],
					post_install_unit: post_install_unit,
				}
			:stretch ->
				%{
					desired_packages: [
						"xserver-xorg-legacy",
						"xserver-xorg-video-nvidia",

						"nvidia-driver-bin",
						"nvidia-kernel-dkms",
						"linux-headers-amd64",
						"nvidia-opencl-icd",
						"nvidia-vdpau-driver",
						"nvidia-settings",
						"nvidia-smi",

						# GLVND flavor, as per debian/nvidia-driver.README.Debian.in
						"libgl1-nvidia-glvnd-glx",
						"libgl1-glvnd-nvidia-glx",
						"nvidia-egl-icd",
						"libglx0-glvnd-nvidia",
						"libegl1-glvnd-nvidia",
						"nvidia-vulkan-common",
					],
					post_install_unit: post_install_unit,
				}
		end
	end
end
