@echo off

lualatex "\def\uncensored{}\input{Thesis}"
makeglossaries Thesis
biber Thesis
lualatex "\def\uncensored{}\input{Thesis}"
lualatex "\def\uncensored{}\input{Thesis}"
