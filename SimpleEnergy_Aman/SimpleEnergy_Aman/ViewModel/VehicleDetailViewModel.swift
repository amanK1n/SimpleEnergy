//
//  VehicleDetailViewModel.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import Foundation
internal import Combine

@MainActor
final class VehicleDetailViewModel: ObservableObject {
    @Published var vehicle: Vehicle
    @Published var isRefreshing = false
    @Published var errorMessage: String?

    private let service: VehicleServiceProtocol

    init(vehicle: Vehicle, service: VehicleServiceProtocol = VehicleService()) {
        self.vehicle = vehicle
        self.service = service
    }

    func refresh() async {
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
