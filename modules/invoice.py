from datetime import datetime
import json

class InvoiceDataProduct:
    def __init__(self, id: str | None = None, description: str | None = None, unit_price: float | None = None, quantity: float | None = None, total: float | None = None, reason: str | None = None):
        self.id = id
        self.description = description
        self.unit_price = unit_price
        self.quantity = quantity
        self.total = total
        self.reason = reason

    id: str | None
    description: str | None
    unit_price: float | None
    quantity: float | None
    total: float | None
    reason: str | None

    def to_json(self):
        return {
            'id': self.id,
            'description': self.description,
            'unit_price': self.unit_price,
            'quantity': self.quantity,
            'total': self.total,
            'reason': self.reason
        }

class InvoiceData:
    def __init__(self, invoice_number: str | None = None, purchase_order_number: str | None = None, customer_name: str | None = None, customer_address: str | None = None, delivery_date: str | None = None, payable_by: str | None = None, products: list[InvoiceDataProduct] | None = None, returns: list[InvoiceDataProduct] | None = None, total_product_quantity: float | None = None, total_product_price: float | None = None):
        self.invoice_number = invoice_number
        self.purchase_order_number = purchase_order_number
        self.customer_name = customer_name
        self.customer_address = customer_address
        self.delivery_date = delivery_date
        self.payable_by = payable_by
        self.products = products
        self.returns = returns
        self.total_product_quantity = total_product_quantity
        self.total_product_price = total_product_price        

    invoice_number: str | None
    purchase_order_number: str | None
    customer_name: str | None
    customer_address: str | None
    delivery_date: str | None
    payable_by: str | None
    products: list[InvoiceDataProduct] | None 
    returns: list[InvoiceDataProduct] | None
    total_product_quantity: float | None
    total_product_price: float | None

    @staticmethod
    def from_json(json_content_str: str):
        json_content = json.loads(json_content_str)
        invoice_number = json_content.get('invoice_number', None)
        purchase_order_number = json_content.get('purchase_order_number', None)
        customer_name = json_content.get('customer_name', None)
        customer_address = json_content.get('customer_address', None)
        delivery_date = json_content.get('delivery_date', None)
        payable_by = json_content.get('payable_by', None)
        products = json_content.get('products', [])
        returns = json_content.get('returns', [])
        total_product_quantity = json_content.get('total_product_quantity', None)
        total_product_price = json_content.get('total_product_price', None)

        invoice_products = []
        for product in products:
            invoice_product = InvoiceDataProduct(
                id=product.get('id', None),
                description=product.get('description', None),
                unit_price=product.get('unit_price', None),
                quantity=product.get('quantity', None),
                total=product.get('total', None)
            )
            invoice_products.append(invoice_product)

        invoice_returns = []
        for return_product in returns:
            invoice_return = InvoiceDataProduct(
                id=return_product.get('id', None),
                quantity=return_product.get('quantity', None),
                reason=return_product.get('reason', None)
            )
            invoice_returns.append(invoice_return)

        return InvoiceData(
            invoice_number=invoice_number,
            purchase_order_number=purchase_order_number,
            customer_name=customer_name,
            customer_address=customer_address,
            delivery_date=delivery_date,
            payable_by=payable_by,
            products=invoice_products,
            returns=invoice_returns,
            total_product_quantity=total_product_quantity,
            total_product_price=total_product_price
        )

    @staticmethod
    def empty():
        invoice_product = InvoiceDataProduct(
                id='',
                description='',
                unit_price=0.0,
                quantity=0.0,
                total=0.0
            )
        invoice_return = InvoiceDataProduct(
                id='',
                description='',
                unit_price=0.0,
                quantity=0.0,
                total=0.0,
                reason=''
            )
        return InvoiceData(invoice_number='', purchase_order_number='', customer_name='', customer_address='', delivery_date=datetime.now().strftime('%Y-%m-%d'), payable_by=datetime.now().strftime('%Y-%m-%d'), products=[invoice_product], returns=[invoice_return], total_product_quantity=0.0, total_product_price=0.0)
    
    @staticmethod
    def empty_json_str():
        empty_invoice = InvoiceData.empty()
        return json.dumps(empty_invoice.to_json())
    
    def to_json(self):
        products = []
        if self.products is None:
            self.products = []
        else:
            for product in self.products:
                if isinstance(product, InvoiceDataProduct):
                    products.append(product.to_json())
                else:
                    print('Products: Expected InvoiceDataProduct, got: ', type(product))

        returns = []
        if self.returns is None:
            self.returns = []
        else:
            for return_product in self.returns:
                if isinstance(return_product, InvoiceDataProduct):
                    returns.append(return_product.to_json())
                else:
                    print('Returns: Expected InvoiceDataProduct, got: ', type(return_product))

        return {
            'invoice_number': self.invoice_number,
            'purchase_order_number': self.purchase_order_number,
            'customer_name': self.customer_name,
            'customer_address': self.customer_address,
            'delivery_date': self.delivery_date,
            'payable_by': self.payable_by,
            'products': products,
            'returns': returns,
            'total_product_quantity': self.total_product_quantity,
            'total_product_price': self.total_product_price
        }