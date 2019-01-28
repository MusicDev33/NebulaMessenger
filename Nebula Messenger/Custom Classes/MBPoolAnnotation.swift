//
//  MBPoolAnnotation.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/28/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import Mapbox

class MBPoolAnnotation: MGLPointAnnotation{
    var imageName: String!
    var id: String!
}

func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) -> MGLPolygon{
    let degreesBetweenPoints = 8.0
    //45 sides
    let numberOfPoints = floor(360.0 / degreesBetweenPoints)
    let distRadians: Double = withMeterRadius / 6371000.0
    // earth radius in meters
    let centerLatRadians: Double = coordinate.latitude * Double.pi / 180
    let centerLonRadians: Double = coordinate.longitude * Double.pi / 180
    var coordinates = [CLLocationCoordinate2D]()
    //array to hold all the points
    for index in 0 ..< Int(numberOfPoints) {
        let degrees: Double = Double(index) * Double(degreesBetweenPoints)
        let degreeRadians: Double = degrees * Double.pi / 180
        let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
        let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
        let pointLat: Double = pointLatRadians * 180 / Double.pi
        let pointLon: Double = pointLonRadians * 180 / Double.pi
        let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
        coordinates.append(point)
    }
    let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
    
    
    return polygon
}
