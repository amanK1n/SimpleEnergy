//
//  VehicleDetailView.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import Foundation
import SwiftUI

struct VehicleDetailView: View {
    @StateObject private var viewModel: VehicleDetailViewModel

    init(vehicle: Vehicle, service: VehicleServiceProtocol = VehicleService()) {
        _viewModel = StateObject(wrappedValue: VehicleDetailViewModel(vehicle: vehicle, service: service))
    }

    var body: some View {
        ScrollView {
            headerSection
            statsGrid
            lastUpdatedSection
        }.navigationTitle(viewModel.vehicle.name)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.refresh() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.vehicle.model)
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(viewModel.vehicle.status)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(viewModel.vehicle.statusColor.opacity(0.15))
                .foregroundStyle(viewModel.vehicle.statusColor)
                .clipShape(Capsule())
        }
    }
    private var statsGrid: some View {
           LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
               statCard(title: "Battery", value: "\(viewModel.vehicle.battery)%", icon: "battery.100", color: viewModel.vehicle.batteryColor)
               statCard(title: "Range", value: "\(viewModel.vehicle.range) km", icon: "road.lanes", color: .blue)
               statCard(title: "Speed", value: "\(viewModel.vehicle.speed) km/h", icon: "speedometer", color: .orange)
               statCard(title: "Odometer", value: "\(viewModel.vehicle.odometer) km", icon: "gauge.with.dots.needle.67percent", color: .purple)
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
          viewModel.vehicle.lastUpdated.formatted(date: .abbreviated, time: .shortened)
      }
}
