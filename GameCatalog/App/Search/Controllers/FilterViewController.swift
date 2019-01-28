import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController {

    var universes: [String] = ["Donkey Kong", "Zelda", "Mario"]

    enum FilterSection: String {
        case category
        case range
        case rate
        case universe
    }

    var datasource: [FilterSection] {
        return [.category, .range, .rate, .universe]
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
            return (section, universes)
        }
    }

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

    init() {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white

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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        self.title = Language.filter.localized()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.allowsMultipleSelection = true
        navigationItem.leftBarButtonItem = backButton
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
            cell.configureUI()
            return cell
        case .range:
            let cellIdentifier = RangePickerTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RangePickerTableViewCell
            cell.configureUI()
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

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].rawValue.capitalized
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
        tableView.indexPathsForSelectedRows?
            .filter { $0.section == indexPath.section }
            .forEach { tableView.deselectRow(at: $0, animated: true) }
        return indexPath
    }
}
