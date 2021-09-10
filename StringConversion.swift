//
//  StringConversion.swift
//  RapCollab
//
//  Created by Charlie Robison on 8/4/21.
//

import Foundation

class StringConversion {
    
    /*Fills every whitespace in word with "%20" to be read by api call.*/
    func convertString(word: String) -> String {
        //Splits word into an array of substrings.
        let components = word.components(separatedBy: " ");
        //Resets word.
        var newWord = ""
        //Loops through each substring.
        for i in 0..<components.count {
            //Adds substring to word.
            newWord += components[i];
            //Checks if i is second to last in list.
            if (i < components.count - 1) {
                //Appends %20 to word.
                newWord += "%20"
            }
        }
        return newWord;
    }
    
    /*Fills every "%20" in word with " " to be read by api call.*/
    func convertStringBack(word: String) -> String {
        //Splits word into an array of substrings.
        let components = word.components(separatedBy: "%20");
        //Resets word.
        var newWord = ""
        //Loops through each substring.
        for i in 0..<components.count {
            //Adds substring to word.
            newWord += components[i];
            //Checks if i is second to last in list.
            if (i < components.count - 1) {
                //Appends " " to word.
                newWord += " "
            }
        }
        return newWord;
    }
}
