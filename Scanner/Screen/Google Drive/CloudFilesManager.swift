//
//  CloudFilesManager.swift
//  Scanner
//
//  Created by Sona on 18.01.24.
//

import Foundation
import GoogleAPIClientForREST

class CloudFilesManager {
    
    private let service: GTLRDriveService

    init(_ service: GTLRDriveService) {
        self.service = service
    }
    
    public func listAllFiles(_ fileName: String, token: String?, onCompleted: @escaping ([GTLRDrive_File]?, String?, Error?) -> ()) {

        let root = "(mimeType = 'image/jpeg' or mimeType = 'image/png' or mimeType = 'application/pdf') and (name contains '\(fileName)')"
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.pageToken = token
        query.q = root
        query.fields = "files(id,name,mimeType,modifiedTime,fileExtension,size,iconLink, thumbnailLink, hasThumbnail),nextPageToken"

        service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files, (results as? GTLRDrive_FileList)?.nextPageToken, error)
        }
    }
}
