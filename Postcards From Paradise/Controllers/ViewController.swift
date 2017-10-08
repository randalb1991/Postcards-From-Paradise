//
//  ViewController.swift
//  Postcards From Paradise
//
//  Created by Randall Dani Barrientos Alva on 5/10/17.
//  Copyright © 2017 Randall Dani Barrientos Alva. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDragDelegate,
                      UIDropInteractionDelegate
{

    //MARK: Attributes

    //Si fuese un tableviewcontroller o haria falta que herede todo lo demás
    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var colors = [UIColor]()
    var image : UIImage?
    
    var toptext = "Top text"
    var bottonText = "Botton text"
    
    var topFontName = "Avenir Next"
    var bottonFontName = "Avenir Next"
    
    var topFontColor = UIColor.white
    var bottonFontColor = UIColor.white
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors += [.black, .gray, .white, .red, .orange, .yellow, .green, .cyan, .blue, .purple, .magenta]
        for hue in 0...9{
            for sat in 1...10{
                let color = UIColor(hue: CGFloat(hue)/10, saturation: CGFloat(sat)/10, brightness: 1, alpha: 1)
                self.colors.append(color)
            }
        }
        self.colorCollectionView.dragDelegate = self // mi propia clase va a responder a los metodos de ser arrastrados
        
        //le damos permiso para ser interactuada al postcard
        self.postcardImageView.isUserInteractionEnabled = true
        // Dejamos definido que seremos nosotros quien responderemos a ese dropinteraction
        
        let dropInteraction = UIDropInteraction(delegate: self)
        renderPosrcard()
        
        self.postcardImageView.addInteraction(dropInteraction)// Necesita 2 metodos:
        // 1: sessiondidupdate-> Donde devolvemosla propuesta de que vamos a soltar al objeto. indica al sistema que info se esta moviendo.
        
        // 2: performdrop: donde se recibe la informacion actual de donde se ha soltado(cuando se suelta el dedo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: Collection view Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Devuelve el numero de secciones. Solo queremos 1
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Devuelve el tamaño de la coleccion
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Funcion que devuelve una celda.
        
        // Desencolamos la celda en la posicion indexpath de la coleccion con identificador "Color Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        //Customizamos la celda
        let color = self.colors[indexPath.row]
        cell.backgroundColor = color
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }

    func renderPosrcard(){
        
        
        // 1. Definir la zona de dibujo rectangular para trabajar 3000x2400
        // La cordenada 0,0 es la esquina superior izquierda, se cuenta a partir de ahí
        let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
        // 2. Crear 2 rectangulos para los 2 textos de la postal
        let topRect = CGRect(x: 300, y: 200, width: 2400, height: 800)
        let bottonRect = CGRect(x: 300, y: 1800, width: 2400, height: 600)
        
        
        
        
        
        
        
        // 3. A partir de los nombres de las fuentes crear los 2 objetos UIFont(). Dejaremos una fuente por defecto por si algo falla
        let topFont = UIFont(name: self.topFontName, size: 250) ?? UIFont.systemFont(ofSize: 240) // Como UIFOnt devuelve un optional, por si no se puede ejecutar ponemos una alternativa
        let bottonFont = UIFont(name: self.bottonFontName, size: 120) ?? UIFont.systemFont(ofSize: 80)
        
        // 4. NSMutableParagraphStyle para centrar el texto en la etiqueta.
        // Se crea el centrado
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        // 5. Definir la estructura de la etiqueta como el color y la fuente(attributed strings NSAttributedStringKey)
        // Creamos un diccionario con los atributos que tendra. uno es la clave y el valor puede ser cualquier cosa(any)
        let topAttributes : [NSAttributedStringKey: Any] =
            [
            .foregroundColor : topFontColor,
            .font: topFont,
            .paragraphStyle : centered
            ]
        
        let bottonAttributes : [NSAttributedStringKey: Any] =
            [
            .foregroundColor : bottonFontColor,
            .font: bottonFont,
            .paragraphStyle : centered
            ]
        
        // 6. Iniciar la renderizacion de la imagen UIGraphicsImageRenderer
        
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        
        self.postcardImageView.image = renderer.image(actions:
            {(context) in
            // 6.1 Renderizar la zona con un fondo gris
            UIColor.lightGray.set()
            context.fill(drawRect)
            // 6.2 Pintaremos la imagen seleccionada por el usuario(si hay alguna) empezando por el borde superior izquierdo.
            self.image?.draw(at: CGPoint(x: 0, y: 0))
            // 6.3 Pintar las dos etiquetas de texto con los parametros configurados en 5
                self.toptext.draw(in: topRect, withAttributes: topAttributes)
                self.bottonText.draw(in: bottonRect, withAttributes: bottonAttributes)
                
        })

    }
    
    // MARK: UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = self.colors[indexPath.row]
        let itemProvider = NSItemProvider(object: color)
        let item = UIDragItem(itemProvider: itemProvider)
        return [item]
    }
    
    // MARK: UIDropInteractionDelegate
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy
        )
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        <#code#>
    }

}

