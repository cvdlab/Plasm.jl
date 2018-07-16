push!(LOAD_PATH,"../src/")

using Documenter, LARVIEW

makedocs(
	format = :html,
	sitename = "LARVIEW.jl",
	pages = [
		"Home" => "index.md",
		"LARVIEW" => "larview.md",
		"Glossary" => "glossary.md"
	]
)
