citeRpacks <- function(pkg_list, filename, RStudio = FALSE, Endnote = FALSE) {

  #ht to https://stackoverflow.com/questions/2470248/write-lines-of-text-to-a-file-in-r for sink()
  for (i in 1:length(pkg_list)) {
      sink(file = paste(filename, ".bib", sep = ""), append = T)
      writeLines(toBibtex(citation(package = pkg_list[i])))
      sink()
  }

  if(RStudio) {

    c <- RStudio.Version()$citation

    sink(file = paste(filename, ".bib", sep = ""), append = T)
    writeLines(paste("@Manual{,",
                     "\n   title = {", c$title, "},",
                     "\n   author = {{", c$author, "}},",
                     "\n   organization = {", c$organization, "},",
                     "\n   address = {", c$address, "},",
                     "\n   year = {", c$year, "},",
                     "\n   note = {", RStudio.Version()$version, "}",
                     "\n   url = {", c$url, "},",
                     "\n }",
                     sep = ""))
    sink()

  }
  
  if(Endnote){
    require("rbibutils")
    bibConvert(infile=paste(filename, ".bib", sep = ""),
      outfile=paste(filename, ".end", sep = ""),
      informat="bibtex", outformat="end")

    endOut <- readLines(paste(filename, ".end", sep = ""))
    endOut <- endOut[!grepl("%F dummy.+",endOut)]

    # Change type of R package entries from "Generic" to "Computer Program" 
    endOut[grepl("%0 Generic",endOut)] <- "%0 Computer Program"
    
    # Avoid EndNote's interpretation of consortium names as First Name Last Name combination
  	endOut[grepl("%A[^,]+$",endOut)] <- paste0(endOut[grepl("%A[^,]+$",endOut)],",")

    write(endOut,paste(filename, ".end", sep = ""))
  }
}
