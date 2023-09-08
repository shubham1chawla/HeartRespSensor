//
//  HistoryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/4/23.
//

import SwiftUI

struct HistoryView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]) var userSessions: FetchedResults<UserSession>
    
    var body: some View {
        NavigationStack {
            List(userSessions, id: \.uuid) { userSession in
                NavigationLink {
                    SummaryView(userSession: userSession)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                    Text(userSession.timestamp!.asTimeAgoFormatted())
                }
            }
        }
        .navigationTitle("History")
    }
    
}

extension Date {
    
    // Formats time nicely for the UI
    func asTimeAgoFormatted() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
}
