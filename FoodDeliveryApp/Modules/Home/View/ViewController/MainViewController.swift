//
//  MainViewController.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 08/09/2021.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift
import Moya

var carouselTimer = 3.0

class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    var presenter: MenuListInterface?
    
    
    @IBOutlet weak var filtersCV: UICollectionView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var adsSpaceCV: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var buttonCart:UIButton?
    
    var labelCart:UILabel?
    
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    var autoScrollTimer = Timer() // Set Timer
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func awakeFromNib() {
        
        setupConfig()
    }
    
    func setupConfig()
    {
        
        
        let failureEndpointClosure = { (target: MenuService) -> Endpoint in
            let sampleResponseClosure = { () -> (EndpointSampleResponse) in
                return .networkResponse(200, target.sampleData)
                
            }
            return Endpoint(url: URL(target: target).absoluteString, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        
        let provider = MoyaProvider<MenuService>(endpointClosure: failureEndpointClosure,stubClosure: MoyaProvider.immediatelyStub)
        
        
        
        
        let interactor =  MainInteractor.init(provider: provider)
        
        let router = MenuListRouter(view:self)
        
        let dependencies = MenuListPresenterDependencies(interactor: interactor, router: router)
        
        let presenter = MainPresenter(dependent: dependencies)
        
        self.presenter = presenter
        
        // data binding
        
        presenter.menuList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        presenter.adsList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.adsSpaceCV.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        presenter.categoryList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.categoryCV.reloadData()
            })
            .disposed(by: disposeBag)
        
        presenter.filterList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.filtersCV.reloadData()
            })
            .disposed(by: disposeBag)
        
        presenter.cartList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                
                self?.reloadCount()
            })
            .disposed(by: disposeBag)
        
    }
    
    func reloadCount()
    {
        if let count = self.presenter?.outputs.cartList.value.count
        {
            self.labelCart?.text = String(count)
            
        }
    }
    
    func setupView()
    {
        
        let button = UIButton.init(frame: CGRect(x: self.view.frame.size.width - 50 - 16, y: self.view.frame.size.height - 50 - 32 , width: 50, height: 50))
        button.backgroundColor = .white
        button.setTitle("", for: .normal)
        button.makeRoundborder(radius: 25)
        button.dropShadow(color: .black, offSet: CGSize(width: -1, height: 1), radius:25)
        button.addTarget(self, action: #selector(gotoCart), for: .touchUpInside)
        self.buttonCart?.alpha = 0
        buttonCart = button
        button.setImage(UIImage.init(named: "cart"), for: .normal)
        self.view.addSubview(button)
        
        
        let labelWidth = 15
        
        //        let label = UILabel.init(frame: CGRect(x: buttonCart?.frame.size.width ?? 0 - labelWidth, y: labelWidth, width: labelWidth, height: labelWidth))
        
        let label = UILabel.init(frame: CGRect(origin: CGPoint(x: (Int(button.frame.size.width) - labelWidth) , y: 0), size: CGSize(width: labelWidth, height: labelWidth)))
        
        label.backgroundColor = UIColor.systemGreen
        label.makeRoundborder(radius: CGFloat(labelWidth/2))
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        self.labelCart = label
        buttonCart?.addSubview(label)
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        //                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        
        
        self.title = "Menu"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setUpTableView()
        setupCollectionView()
        // Do any additional setup after loading the view.
        //        setupConfig()
        
        self.presenter?.inputs.viewDidLoad()
        

    }
    
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 500
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        
        
    }
    
    private func setupCollectionView() {
        adsSpaceCV.dataSource = self
        adsSpaceCV.delegate = self
        categoryCV.delegate = self
        categoryCV.dataSource = self
        filtersCV.delegate = self
        filtersCV.dataSource = self
        
        adsSpaceCV.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarUIView?.backgroundColor = .black
        
                autoScrollTimer.invalidate()
                autoScrollTimer =  Timer.scheduledTimer(timeInterval: carouselTimer, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
        
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
        
        autoScrollTimer.invalidate()
        super.viewWillDisappear(animated)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = self.adsSpaceCV.contentOffset;
        
        if self.adsSpaceCV.contentSize.width <= self.adsSpaceCV.contentOffset.x + cellSize.width
        {
            
            let rect:CGRect = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            self.adsSpaceCV.scrollRectToVisible(rect, animated: true);
            self.pageControl.currentPage = 0
            
            
        } else {
            
            let rect:CGRect = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            
            self.adsSpaceCV.scrollRectToVisible(rect, animated: true);
            let indexPath:IndexPath = self.adsSpaceCV.indexPathForItem(at: rect.origin) ?? IndexPath(row: 0, section: 0)
            
            self.pageControl.currentPage = indexPath.row
            
        }
        
    }
    func animateButton()
    {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = false
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1
        animationGroup.animations = [pulse1]

        self.labelCart?.layer.add(animationGroup, forKey: "pulse")
    }
    
    // MARK: - Scroll View
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if (scrollView == self.adsSpaceCV)
        {
            let collectionView = self.adsSpaceCV
            let pageWidth = Float(collectionView!.frame.size.width)
            let targetXContentOffset = Float(targetContentOffset.pointee.x)
            let contentWidth = Float(collectionView!.contentSize.width  )
            var newPage = Float(self.pageControl.currentPage)
            
            if velocity.x == 0 {
                newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
            } else {
                newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
                if newPage < 0 {
                    newPage = 0
                }
                if (newPage > contentWidth / pageWidth) {
                    newPage = ceil(contentWidth / pageWidth) - 1.0
                }
            }
            
            self.pageControl.currentPage = Int(newPage)
            let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
            targetContentOffset.pointee = point
        }
        
        
    }
    
}

// MARK: - Table View



extension MainViewController : UITableViewDelegate, UITableViewDataSource, cellOutput
{
    func buttonClicked(sender: AnyObject) {
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)

        if  let order = self.presenter?.outputs.menuList.value[indexPath!.row]  {
            
            self.presenter?.inputs.addToCart(order: [order])
            
            animateButton()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.presenter?.outputs.menuList.value.count
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MainTableViewCell
        
        cell.delegate = self
        
        let menu = self.presenter?.outputs.menuList.value[indexPath.row]
        
        if let url = URL(string: menu?.menuImageUrl ?? "")
        {
            cell.imgView.af.setImage(withURL:url)
            
        }
        
        
        cell.title.text = menu?.menuName
        cell.desc.text = menu?.MenuDesc
        cell.content.text = menu?.menuContent
        
        
        let price =  menu?.menuPrice ?? ""
        cell.buttonOrder.setTitle("\(price) usd", for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (scrollView == self.tableView)
        {
            if (scrollView.contentOffset.y < 0){
                //reach top
                
                UIView.animate(withDuration: 0.5) {
                    self.buttonCart?.alpha = 0
                    
                }
                
            }
            else if (scrollView.contentOffset.y >= 100)
            
            {
                UIView.animate(withDuration: 0.5) {
                    self.buttonCart?.alpha = 1
                    
                }
                

            }
            
            let height  = self.view.frame.size.height
            let ratio  = Double(scrollView.contentOffset.y/height)
            let value = 1 - (ratio)
           
            self.adsSpaceCV.alpha = CGFloat(value)

        }
        
    }
    
}
// MARK: - Router

extension MainViewController
{
    @objc func gotoCart ()
    {
        self.presenter?.inputs.gotoCart()
        
    }
}

// MARK: - Collection View

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (collectionView == self.adsSpaceCV)
        {
            
            return self.presenter?.outputs.adsList.value.count ?? 0
        }
        else  if (collectionView == self.categoryCV)
        {
            return self.presenter?.outputs.categoryList.value.count ?? 0
            
        }
        else  if (collectionView == self.filtersCV)
        {
            return self.presenter?.outputs.filterList.value.count ?? 0
            
        }
        
        
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if (collectionView == self.adsSpaceCV)
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! MainCollectionViewCell
            
            
            let item  = self.presenter?.outputs.adsList.value[indexPath.row]
            
            if let url = URL(string: item!)
            {
                cell.imageView.af.setImage(withURL: url)
                
            }
            
            
            return cell
        }
        
        else  if (collectionView == self.categoryCV)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CategorySelectorCollectionViewCell
            
            let item  = self.presenter?.outputs.categoryList.value[indexPath.row]
            
            if let string = item
            {
                cell.title.text = string
                
            }
            
            cell.setSelected(selectedIndex.row == indexPath.row, animated: false)
            
            return cell
        }
        else if (collectionView == self.filtersCV)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! FiltersCollectionViewCell
            
            let item  = self.presenter?.outputs.filterList.value[indexPath.row]
            if let string = item
            {
                cell.title.text = string
                
            }
            
            return cell
            
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if (collectionView == self.adsSpaceCV)
        {
            
        }
        else  if (collectionView == self.categoryCV)
        {
            
            if (indexPath != selectedIndex){
                let indexPath_pre = selectedIndex
                let indexPath_post = indexPath
                
                let array = [indexPath_pre,indexPath_post]
                
                self.selectedIndex = indexPath
                
                collectionView.reloadItems(at: array)
            }
            
        }
        else  if (collectionView == self.filtersCV)
        {
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == self.adsSpaceCV)
        {
            return CGSize(width: self.view.frame.width, height: 600)
            
        }
        else  if (collectionView == self.categoryCV)
        {
            let item  = self.presenter?.outputs.categoryList.value
            
            if let count = item?.count
            {
                let value = (Int(count) *  13) + 32
                
                return CGSize(width: value, height: 50)
                
            }
            
        }
        else  if (collectionView == self.filtersCV)
        {
            let item  = self.presenter?.outputs.filterList.value
            
            if let count = item?.count
            {
                let value = (Int(count) *  13) + 32
                
                return CGSize(width: value, height: 50)
                
            }
            
        }
        
        
        return CGSize(width: 0, height: 0)
        
    }
  
    

    
}
