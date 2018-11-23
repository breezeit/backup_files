�ü��±���:
EditSelectedFiles()
Return

EditSelectedFiles()
{
	global ImageExtensions,TextEditor,ImageEditor
	ImageExtensions = jpg,png,bmp,gif,tga,tif,ico,jpeg
	files:=GetSelectedFiles()
	SplitByExtension(files, splitfiles, ImageExtensions)
	files:=RemoveLineFeedsAndSurroundWithDoubleQuotes(files)
	splitfiles:=RemoveLineFeedsAndSurroundWithDoubleQuotes(splitfiles)
	x:=ExpandEnvVars(TextEditor)
	y:=ExpandEnvVars(ImageEditor)
	if(!FileExist(x))
    TrayTip,���ô���,�ı��༭����·������,3
	if(!FileExist(y))
	 TrayTip,���ô���,ͼƬ�༭����·������,3
	if (files || splitfiles)
	{
		if files
			run %x% %files%
		if splitfiles
			run %y% %splitfiles%
	}
	else
		SendInput {F6}
	return
}

SplitByExtension(ByRef files, ByRef SplitFiles,extensions)
{
	;Init string incase it wasn't resetted before or so
	Splitfiles:=""
	Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds ('r`n).
	{
		SplitPath, A_LoopField , , , OutExtension
	  if (InStr(extensions, OutExtension) && OutExtension!="")
	  {
	  	Splitfiles .= A_LoopField "`n"
	  }
	  else
	  {
	  	newFiles .= A_LoopField "`n"
	  }
	}
	files:=strTrimRight(newFiles,"`n")
	SplitFiles:=strTrimRight(SplitFiles,"`n")
	return
}

RemoveLineFeedsAndSurroundWithDoubleQuotes(files)
{
	result:=""
	Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds ('r`n).
   {
      if !InStr(FileExist(A_LoopField), "D")
   			result=%result% "%A_LoopField%"
   }
   return result
}