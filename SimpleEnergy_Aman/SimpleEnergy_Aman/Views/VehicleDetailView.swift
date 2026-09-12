//
//  VehicleDetailView.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import Foundation
import SwiftUI

struct VehicleDetailView: View {
    @State var vehicle: Vehicle
    @State private var isRefreshing = false
    @State private var errorMessage: String?
    private let service: VehicleServiceProtocol
    
    init(vehicle: Vehicle, service: VehicleServiceProtocol = VehicleService()) {
        _vehicle = State(initialValue: vehicle)
        self.service = service
    }
    
    
    var body: some View {
        ScrollView {
            headerSection
            statsGrid
            lastUpdatedSection
        }.navigationTitle(vehicle.name)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await refresh() }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vehicle.model)
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(vehicle.status)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(vehicle.statusColor.opacity(0.15))
                .foregroundStyle(vehicle.statusColor)
                .clipShape(Capsule())
        }
    }
    private var statsGrid: some View {
           LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
               statCard(title: "Battery", value: "\(vehicle.battery)%", icon: "battery.100", color: vehicle.batteryColor)
               statCard(title: "Range", value: "\(vehicle.range) km", icon: "road.lanes", color: .blue)
               statCard(title: "Speed", value: "\(vehicle.speed) km/h", icon: "speedometer", color: .orange)
               statCard(title: "Odometer", value: "\(vehicle.odometer) km", icon: "gauge.with.dots.needle.67percent", color: .purple)
           }
       }
       private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
           VStack(alignment: .leading, spacing: 8) {
               Label(title, systemImage: icon)
                   .font(.caption)
                   .foregroundStyle(.secondary)
               Text(value)
                   .font(.title3)
                   .fontWeight(.semibold)
                   .foregroundStyle(color)
           }
           .frame(maxWidth: .infinity, alignment: .leading)
           .padding()
           .background(Color(.secondarySystemBackground))
           .clipShape(RoundedRectangle(cornerRadius: 12))
       }
    private var lastUpdatedSection: some View {
           HStack {
               Image(systemName: "clock")
                   .foregroundStyle(.secondary)
               Text("Last updated: \(formattedDate)")
                   .font(.footnote)
                   .foregroundStyle(.secondary)
           }
       }
    private var formattedDate: String {
          vehicle.lastUpdated.formatted(date: .abbreviated, time: .shortened)
      }
    private func refresh() async {
        isRefreshing = true
        errorMessage = nil
        defer { isRefreshing = false }

        do {
            let vehicles = try await service.fetchVehicles()
            if let updated = vehicles.first(where: { $0.id == vehicle.id }) {
                vehicle = updated
            } else {
                errorMessage = "Vehicle not found"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
