alias Converge.Util

defmodule RoleNvidia do
	require Util
	Util.declare_external_resources("files")

	def role(tags \\ []) do
		release = Util.tag_value!(tags, "release") |> String.to_atom()
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
					apt_keys:    [Util.content("files/apt_keys/1118213C Launchpad PPA for Graphics Drivers Team.gpg")],
					apt_sources: ["deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu xenial main"],
				}
			:stretch ->
				%{
					desired_packages: [
						"nvidia-driver-bin",
						"nvidia-kernel-dkms",
						"linux-headers-amd64",
						"libcuda1",
						"nvidia-libopencl1",
						"nvidia-opencl-icd",
						"nvidia-settings",
						"nvidia-smi",
					]
				}
		end
	end
end
