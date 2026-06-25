<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

[![Topology](https://img.shields.io/badge/Project-Topology-9558B2)](TOPOLOGY.md)
[![20](https://img.shields.io/badge/Completion-20%25-red)](TOPOLOGY.md) [![OpenSSF Best Practices](https://img.shields.io/badge/OpenSSF-Best_Practices-green?logo=opensourcesecurity)](https://www.bestpractices.dev/en/projects/new?repo_url=https://github.com/hyperpolymath/MacroPower.jl) ![License:
PMPL-1.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg) <embed
src="https://api.thegreenwebfoundation.org/greencheckimage/github.com"
data-link="https://www.thegreenwebfoundation.org/green-web-check/?url=github.com" />

**The Automation Engine for the Hyperpolymath Ecosystem.**

MacroPower.jl is a low-code/no-code style automation tool for Julia. It
allows you to define "Flows" that connect events (File System, HTTP,
Time) to actions (Run Script, Send Alert, Database Write).

# Quick Start

```julia
using MacroPower

# Define a flow
flow = @workflow "Nightly Backup" begin
    when(time_is("02:00")) -> backup_database()
    when(file_changed("/tmp/data")) -> process_data()
end

run_workflow(flow)
```
