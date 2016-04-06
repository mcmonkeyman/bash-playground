#!/bin/sh
SCRIPT="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
DIR=`dirname "${SCRIPT}"}`
exec scala $0 $DIR $SCRIPT
::!#

import java.io.File
import java.net.URL
import scala.sys.process._

object App {
  def main(args: Array[String]): Unit = {
    //getBashArguments(args)
    //simpleFileManipulations()
    //simpleChaining()
    //fileExists("README.md")
    backupIfNew("https://us2.hostedftp.com/files/")
  }

  def getBashArguments(args: Array[String]): Unit = {
    val Array(directory,script) = args.map(new File(_).getAbsolutePath)
    println("Executing '%s' in directory '%s'".format(script, directory))
  }

  def simpleFileManipulations(): Unit = {
    val result  = "ls -al".!!
    println(result)
    ()
  }

  def simpleChaining(): Unit = {
    "ls" #| "grep .scala" #&& "scalac *.scala" #|| "echo nothing found" lines
  }

  // This uses ! to get the exit code
  def fileExists(name: String) = Seq("test", "-f", name).! == 0

  // This "fire-and-forgets" the method, which can be lazily read through
  // a Stream[String]
  def simpleSourceFilesAt(baseDir: String): Stream[String] = {
    val cmd = Seq("find", baseDir, "-name", "*.scala", "-type", "f")
    cmd.lines
  }

  // This "fire-and-forgets" the method, which can be lazily read through
  // a Stream[String], and accumulates all errors on a StringBuffer
  def sourceFilesAt(baseDir: String): (Stream[String], StringBuffer) = {
    val buffer = new StringBuffer()
    val cmd = Seq("find", baseDir, "-name", "*.scala", "-type", "f")
    val lines = cmd lines_! ProcessLogger(buffer append _)
    (lines, buffer)
  }

  def backupIfNew(fileUrl: String) = {

    val currentFileName = "./current.file"
    val tempFileName = "./tmp.file"
    new URL(fileUrl) #> new File(tempFileName) !!

    val currentFile = new File(currentFileName)
    val tempFile = new File(tempFileName)

    if(isNotTheSame(currentFile, tempFile)) {
      println("not the same")
     // Make the new file 
    } else {
      println("the same")
    }
  }

  def isNotTheSame(fileA: File, fileB: File ) = {
    !isSame(fileA, fileB)
  }

  def isSame(fileA: File, fileB: File) = {
    ckSum(fileA) == ckSum(fileB)
  }


  def ckSum(file: File): Tuple2[String, String] = {
   val pattern = "(\\d+) (\\d+).*".r
   val result: String = Seq("ckSum", file.getName()).!!
   val cleanResult: String = result.trim.stripLineEnd.trim
   val pattern(a, b) = cleanResult 
   (a, b)
  }

}
