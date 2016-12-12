import sys
import PyQt5
from PyQt5 import QtGui
from PyQt5 import QtWidgets
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

class MainWindow(QtWidgets.QMainWindow):
   def __init__(self, parent=None):
      super(MainWindow, self).__init__(parent)
      self.central_widget = QtWidgets.QStackedWidget()
      self.setCentralWidget(self.central_widget)
      page1_widget = Page1Widget(self)
      page1_widget.button.clicked.connect(self.gotopage2)
      self.central_widget.addWidget(page1_widget)

   def gotopage2(self):
      page2_widget = Page2Widget(self)
      page2_widget.button.clicked.connect(self.gotopage3)
      self.central_widget.addWidget(page2_widget)
      self.central_widget.setCurrentWidget(page2_widget)
   def gotopage3(self):
      page3_widget = Page3Widget(self)
      page3_widget.button.clicked.connect(self.gotopage4)
      self.central_widget.addWidget(page3_widget)
      self.central_widget.setCurrentWidget(page3_widget)
   def gotopage4(self):
      page4_widget = Page4Widget(self)
      page4_widget.button.clicked.connect(self.gotopage2)
      self.central_widget.addWidget(page4_widget)
      self.central_widget.setCurrentWidget(page4_widget)

class Page1Widget(QtWidgets.QWidget):
   def __init__(self, parent=None):
      super(Page1Widget, self).__init__(parent)
      layout = QHBoxLayout()
      self.button = QtWidgets.QPushButton('goto Page2')
      layout.addWidget(self.button)
      self.setLayout(layout)

class Page2Widget(QtWidgets.QWidget):
   def __init__(self, parent=None):
      super(Page2Widget, self).__init__(parent)
      layout = QHBoxLayout()
      self.label = QLabel('in page2')
      layout.addWidget(self.label)
      self.button = QtWidgets.QPushButton('goto Page3')
      layout.addWidget(self.button)
      self.setLayout(layout)

class Page3Widget(QtWidgets.QWidget):
   def __init__(self, parent=None):
      super(Page3Widget, self).__init__(parent)
      layout = QHBoxLayout()
      self.label = QLabel('in page3')
      layout.addWidget(self.label)
      self.button = QtWidgets.QPushButton('goto Page4')
      layout.addWidget(self.button)
      self.setLayout(layout)

class Page4Widget(QtWidgets.QWidget):
   def __init__(self, parent=None):
      super(Page4Widget, self).__init__(parent)
      layout = QHBoxLayout()
      self.label = QLabel('in page4')
      layout.addWidget(self.label)
      self.button = QtWidgets.QPushButton('return to Page2')
      layout.addWidget(self.button)
      self.setLayout(layout)

if __name__ == '__main__':
   app = QApplication(sys.argv)
   window = MainWindow()
   window.show()
   app.exec_()
