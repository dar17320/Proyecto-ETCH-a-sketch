#------------------------------------------------------
# José Eduardo Morales
# basado en:
# https://www.learnpyqt.com/courses/start/
# https://www.learnpyqt.com/courses/custom-widgets/bitmap-graphics/
#------------------------------------------------------
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *

        
class MainWindow(QMainWindow):

    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)
        
        # Título de la ventana
        self.setWindowTitle("Mi App")
        self.setWindowIcon(QIcon("animal-dog.png"))

        # Creación de la barra de herramientas
        toolbar = QToolBar("My main toolbar")
        toolbar.setIconSize(QSize(16,16))
        self.addToolBar(toolbar)

        # Primer icono
        button_action = QAction(QIcon("safe.png"), "Tooltip safe", self)
        button_action.setStatusTip("Status Safe")
        button_action.triggered.connect(self.onMyToolBarButtonClick)
        button_action.setCheckable(True) # checkeable
        toolbar.addAction(button_action)

        # Segundo Icono
        toolbar.addSeparator()
        
        button_action2 = QAction(QIcon("printer.png"), "Tooltip print", self)
        button_action2.setStatusTip("Status Print")
        button_action2.triggered.connect(self.onMyToolBarButtonClick_button2)
        toolbar.addAction(button_action2)

        # asignar la barra inferior de status
        self.setStatusBar(QStatusBar(self))

        # orden horizontal
        layoutH = QHBoxLayout()
        # orden vertical
        layout1 = QVBoxLayout()
        layout2 = QVBoxLayout()


        # caja de menu desplegable
        self.cbox = QComboBox()
        self.cbox.addItems(["One", "Two", "Three"])
        layout1.addWidget(self.cbox)

        # etiqueta para mostrar texto
        self.label = QLabel("Press ->")
        layout1.addWidget(self.label)
        
        # boton 1
        self.b1 = QPushButton("Paint")
        self.b1.clicked.connect(self.btn1)
        layout2.addWidget(self.b1)

        # boton 2
        self.b2 = QPushButton("Ok")
        self.b2.clicked.connect(self.btn2)
        layout2.addWidget(self.b2) 

        self.labelDraw = QLabel()
        canvas = QPixmap(400, 300)
        canvas.fill(QColor("green"))
        self.labelDraw.setPixmap(canvas)
        
        # agregar los layouts secundarios al principal
        layoutH.addLayout(layout1)
        layoutH.addLayout(layout2)
        layoutH.addWidget(self.labelDraw)
        
        # agregar el layout al widget central
        widget = QWidget()
        widget.setLayout(layoutH)
        
        # Set the central widget of the Window. Widget will expand
        # to take up all the space in the window by default.
        self.setCentralWidget(widget)
        

    # evento de click en el toolbar    
    def onMyToolBarButtonClick(self, s):
        print("click", s)
        self.label.setText(self.cbox.currentText())

    # evento de click en el toolbar    
    def onMyToolBarButtonClick_button2(self, s):
        print("click", s)
        self.label.setText("2 " + self.cbox.currentText())

    # evento del boton 1
    def btn1(self):
        self.b1.setText("Painted")
        self.draw_something()

    # evento del boton 2
    def btn2(self, b):
        print ("clicked button is " + self.b2.text())
        self.label.setText(self.cbox.currentText())

    def draw_something(self):
        painter = QPainter(self.labelDraw.pixmap())
        pen = QPen()
        pen.setWidth(40)
        pen.setColor(QColor('red'))
        painter.setPen(pen)
        painter.drawPoint(200, 150)
        painter.end()
        self.update()
        print("drawing")

# crear la applicación        
app = QApplication(sys.argv)

# crear la ventana y mostrarla
window = MainWindow()
window.show()

app.exec_()
