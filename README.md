prawn_business_docs
===================

prawn example 'letterhead' document also derived business documents

letterhead_pdf.rb    == base class for my business documents, derived from prawn 'document' class
order_pdf.rb         == order document derived from 'letterhead' class
orders_controller.rb == fragment of controller showing init and creation of pdf

order_20.pdf         == example pdf created by order_pdf class