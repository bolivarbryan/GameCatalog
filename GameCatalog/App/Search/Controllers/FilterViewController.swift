import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController {

    enum FilterSection: String {
        case category
        case range
        case rate
        case universe
    }

    var datasource: [FilterSection] {
        return [.category, .range, .rate, .universe]
    }

    let viewModel: FilterViewModel
    let tableView: UITableView
    let bag = DisposeBag()

    var backButton: UIBarButtonItem {
        let button = UIBarButtonItem(title: Language.close.localized().capitalized,
                                         style: .plain,
                                         target: self,
                                         action: nil)

        button.tintColor = GCStyleKit.fuschia

        guard
            let font =  UIFont(name: "Helvetica-Bold", size: 17.0)
            else { fatalError("This Font should be found in system") }

        button.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        button.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .highlighted )
        button.rx.tap.asObservable().subscribe(onNext:{ _ in
            self.dismiss(animated: true, completion: nil)
        })
            .disposed(by: bag)
        return button
    }

    init(universes: [String]) {
        self.viewModel = FilterViewModel(universes: universes)
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .groupTableViewBackground

        tableView.register(FilterSelectionTableViewCell.self,
                           forCellReuseIdentifier: FilterSelectionTableViewCell.identifier)
        tableView.register(RateSelectionTableViewCell.self,
                           forCellReuseIdentifier: RateSelectionTableViewCell.identifier)
        tableView.register(RangePickerTableViewCell.self,
                           forCellReuseIdentifier: RangePickerTableViewCell.identifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateSection(section: FilterSection) -> (type: FilterSection, elements: [String]) {
        switch section {
        case .category:
            return (section, ["Downloads", "Date added", "Price"])
        case .range:
            return (section, [])
        case .rate:
            return (section, (1...5).map({"\($0)"}))
        case .universe:
            return (section, viewModel.universes)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        self.title = Language.filter.localized()

        let applyFilterButton = GCButton(title: Language.apply.localized().capitalized)
        view.addSubview(applyFilterButton)
        applyFilterButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-32)
        })

        applyFilterButton.rx.tap.asObservable()
            .subscribe(onNext:{ _ in
                print(self.viewModel)
            })
            .disposed(by: bag)

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.bottom.equalTo(applyFilterButton.snp.top).offset(-17)
        }
        tableView.allowsMultipleSelection = true
        navigationItem.leftBarButtonItem = backButton
        tableView.backgroundColor = .groupTableViewBackground
        tableView.sectionHeaderHeight = 5
        tableView.separatorStyle = .none
    }
    
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = generateSection(section: datasource[indexPath.section])

        switch section.type {
        case .category:
            let cellIdentifier = FilterSelectionTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FilterSelectionTableViewCell
            cell.value = section.elements[indexPath.row]
            cell.checkmarkStyle = .circled
            cell.contentStyle = .text
            cell.configureUI()
            return cell
        case .range:
            let cellIdentifier = RangePickerTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RangePickerTableViewCell
            cell.configureUI()
            cell.delegate = self
            return cell
        case .rate:
            let cellIdentifier = FilterSelectionTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FilterSelectionTableViewCell
            cell.value = section.elements[indexPath.row]
            cell.checkmarkStyle = .squared
            cell.contentStyle = .rate
            cell.configureUI()
            return cell
        case .universe:
            let cellIdentifier = FilterSelectionTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FilterSelectionTableViewCell
            cell.value = section.elements[indexPath.row]
            cell.checkmarkStyle = .circled
            cell.contentStyle = .text
            cell.configureUI()
            return cell
        }
    }
}

extension FilterViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionData = generateSection(section: datasource[section])

        switch sectionData.type {
        case .category, .rate, .universe:
            return sectionData.elements.count
        case .range:
            return 1
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = generateSection(section: datasource[indexPath.section])

        switch sectionData.type {
        case .category :
            viewModel.categorySelected = sectionData.elements[indexPath.row]
        case .rate:
            guard
                let value = Int(sectionData.elements[indexPath.row])
                else { return }
            viewModel.addOrRemoveRateValue(value)
        case .universe:
            viewModel.selectedUniverse = sectionData.elements[indexPath.row]
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionData = generateSection(section: datasource[indexPath.section])

        switch sectionData.type {
        case .range:
            return 74
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionData = generateSection(section: datasource[indexPath.section])

        if sectionData.type == .rate {
            return indexPath
        }

        tableView.indexPathsForSelectedRows?
            .filter { $0.section == indexPath.section}
            .forEach { tableView.deselectRow(at: $0, animated: true) }
        return indexPath
    }
}

extension FilterViewController: RangePickerTableViewCellDelegate {
    func didSelectRange(range: (Double, Double)) {
        viewModel.priceRange = range
    }
}
