//
//  WeatherViewModel.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

enum MultipleSectionModel {
    case SelectCitySection(title: String, items: [SectionItem])
    case SearchLocationSection(title: String, items: [SectionItem])
    case SearchCitySection(title: String, items: [SectionItem])
}

enum SectionItem {
    case SelectCityItem(name: String)
    case SearchLocationSectionItem(title: String)
    case SearchCityItem(title: String)
}

enum SearchType {
    case city, coordinate
}

class WeatherViewModel {
    
    var latitude: String? = ""
    var longitude: String? = ""
    var city: String? = ""
    
    let disposeBag = DisposeBag()
    
    var service: Network!
    
    var weather = PublishSubject<Forecast>()
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { dataSource, table, idxPath, _ in
                switch dataSource[idxPath] {
                case let .SelectCityItem(name):
                    guard let cell = table.dequeueReusableCell(withIdentifier: SelectCityTableCell.identifier, for: idxPath) as? SelectCityTableCell else {
                        return UITableViewCell()
                    }
                    cell.configure(name: name)
                    return cell
                case let .SearchLocationSectionItem(title):
                    guard let cell = table.dequeueReusableCell(withIdentifier: SearchLocationCell.identifier, for: idxPath) as? SearchLocationCell else {
                        return UITableViewCell()
                    }
                    cell.configure(placeholder: title)
                    
                    if idxPath.row == 0 {
                        cell.txtField.rx.text.bind { text in
                            self.latitude = text
                        }.disposed(by: self.disposeBag)
                    } else {
                        cell.txtField.rx.text.bind { text in
                            self.longitude = text
                        }.disposed(by: self.disposeBag)
                    }
                    return cell
                case let .SearchCityItem(title):
                    guard let cell = table.dequeueReusableCell(withIdentifier: SearchLocationCell.identifier, for: idxPath) as? SearchLocationCell else {
                        return UITableViewCell()
                    }
                    cell.txtField.rx.text.bind { text in
                        self.city = text
                    }.disposed(by: self.disposeBag)
                    
                    cell.configure(placeholder: title)
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            }
        )
    }
    
    
    func search(type: SearchType) {
//        switch type
    }
}


extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem

    var items: [SectionItem] {
        switch self {
        case .SelectCitySection(title: _, items: let items):
            return items.map{ $0 }
        case .SearchLocationSection(title: _, items: let items):
            return items.map { $0 }
        case .SearchCitySection(title: _, items: let items):
            return items.map { $0 }
        }
    }



    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .SelectCitySection(title: title, items: items):
            self = .SelectCitySection(title: title, items: items)
        case let .SearchLocationSection(title: title, items: items):
            self = .SearchLocationSection(title: title, items: items)
        case let .SearchCitySection(title: title, items: items):
            self = .SearchCitySection(title: title, items: items)
        }
    }
}


extension MultipleSectionModel {
    var title: String {
        switch self {
        case .SelectCitySection(title: let title, items: _):
            return title
        case .SearchLocationSection(title: let title, items: _):
            return title
        case .SearchCitySection(title: let title, items: _):
            return title
        }
    }
}
