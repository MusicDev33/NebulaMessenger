//
//  CanvasRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/9/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation

struct CanvasCourse {
    let courseName: String
    let courseId: String
    var courseToken: String
}


// First Course
let nebulaByShelbyToken = "Bearer 7~rA3hfeZEk9iY5Ag0NjNzqgXn0Gq7uoGaUi1EkPapqLvax1lb0dWHSOZPtBVMB1kP"
let nebulaByShelby = CanvasCourse(courseName: "Nebula by Shelby", courseId: "1499661", courseToken: nebulaByShelbyToken)

let canvasCourseBaseUrl = "https://canvas.instructure.com/api/v1/courses/"

let courseUrl = "https://canvas.instructure.com/api/v1/courses/1499661/students"

func createGetStudentsUrl(courseId: String) -> String{
    return canvasCourseBaseUrl + courseId + "/" + "students"
}
