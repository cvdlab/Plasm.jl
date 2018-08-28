push!(LOAD_PATH,"../src/")

using Documenter, LARVIEW

makedocs(
	format = :html,
	sitename = "Plasm.jl",
	pages = [
		"Home" => "index.md",
		"Visualization" => "larview.md",
		"Numbering" => "numbering.md",
		"Glossary" => "glossary.md"
	]
)
