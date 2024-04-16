package main

import data.kubernetes

name := input.metadata.name

warn[msg] {
	msg = sprintf("", [name])
}
