// Product Designer with TUI Image Editor Integration
class ProductDesigner {
  constructor(containerId, productImageUrl) {
    this.containerId = containerId;
    this.productImageUrl = productImageUrl;
    this.editor = null;
    this.currentDesign = {
      text: [],
      images: [],
      logos: []
    };
    this.init();
  }

  init() {
    // Create the designer container
    this.createDesignerHTML();
    
    // Initialize TUI Image Editor (placeholder for now)
    this.initImageEditor();
    
    // Bind events
    this.bindEvents();
  }

  createDesignerHTML() {
    const container = document.getElementById(this.containerId);
    container.innerHTML = `
      <div class="product-designer">
        <div class="row">
          <div class="col-md-8">
            <div class="design-canvas-container">
              <div class="product-preview">
                <img id="product-base-image" src="${this.productImageUrl}" alt="Product" class="img-fluid">
                <div id="design-overlay" class="design-overlay"></div>
              </div>
              <div id="tui-image-editor" style="height: 500px;"></div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="design-tools">
              <div class="card">
                <div class="card-header">
                  <h5>Design Tools</h5>
                </div>
                <div class="card-body">
                  <!-- Text Tool -->
                  <div class="tool-section mb-4">
                    <h6><i class="fas fa-font me-2"></i>Add Text</h6>
                    <div class="mb-2">
                      <input type="text" id="text-input" class="form-control" placeholder="Enter text">
                    </div>
                    <div class="row mb-2">
                      <div class="col-6">
                        <select id="font-family" class="form-select form-select-sm">
                          <option value="Arial">Arial</option>
                          <option value="Helvetica">Helvetica</option>
                          <option value="Times">Times</option>
                          <option value="Georgia">Georgia</option>
                        </select>
                      </div>
                      <div class="col-6">
                        <input type="number" id="font-size" class="form-control form-control-sm" value="24" min="8" max="72">
                      </div>
                    </div>
                    <div class="row mb-2">
                      <div class="col-6">
                        <input type="color" id="text-color" class="form-control form-control-color" value="#000000">
                      </div>
                      <div class="col-6">
                        <button id="add-text-btn" class="btn btn-primary btn-sm w-100">Add Text</button>
                      </div>
                    </div>
                  </div>

                  <!-- Logo Upload Tool -->
                  <div class="tool-section mb-4">
                    <h6><i class="fas fa-image me-2"></i>Add Logo</h6>
                    <div class="mb-2">
                      <input type="file" id="logo-upload" class="form-control form-control-sm" accept="image/*">
                    </div>
                    <button id="add-logo-btn" class="btn btn-secondary btn-sm w-100">Add Logo</button>
                  </div>

                  <!-- Embroidery Estimator -->
                  <div class="tool-section mb-4">
                    <h6><i class="fas fa-calculator me-2"></i>Stitch Estimator</h6>
                    <div class="stitch-estimate">
                      <div class="d-flex justify-content-between">
                        <span>Estimated Stitches:</span>
                        <span id="stitch-count">0</span>
                      </div>
                      <div class="d-flex justify-content-between">
                        <span>Estimated Cost:</span>
                        <span id="embroidery-cost">$0.00</span>
                      </div>
                      <small class="text-muted">Based on design complexity</small>
                    </div>
                  </div>

                  <!-- Design Actions -->
                  <div class="tool-section">
                    <h6><i class="fas fa-save me-2"></i>Design Actions</h6>
                    <div class="d-grid gap-2">
                      <button id="save-design-btn" class="btn btn-success btn-sm">Save Design</button>
                      <button id="clear-design-btn" class="btn btn-warning btn-sm">Clear Design</button>
                      <button id="add-to-cart-btn" class="btn btn-primary">Add to Cart</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  initImageEditor() {
    // For now, we'll use a simple overlay system
    // TODO: Integrate actual TUI Image Editor when available
    this.overlay = document.getElementById('design-overlay');
    this.productImage = document.getElementById('product-base-image');
    
    // Make overlay positioned relative to product image
    this.overlay.style.position = 'absolute';
    this.overlay.style.top = '0';
    this.overlay.style.left = '0';
    this.overlay.style.width = '100%';
    this.overlay.style.height = '100%';
    this.overlay.style.pointerEvents = 'none';
    
    // Make product preview container relative
    const previewContainer = this.overlay.parentElement;
    previewContainer.style.position = 'relative';
    previewContainer.style.display = 'inline-block';
  }

  bindEvents() {
    // Add text functionality
    document.getElementById('add-text-btn').addEventListener('click', () => {
      this.addText();
    });

    // Add logo functionality
    document.getElementById('add-logo-btn').addEventListener('click', () => {
      this.addLogo();
    });

    // Logo upload
    document.getElementById('logo-upload').addEventListener('change', (e) => {
      this.handleLogoUpload(e);
    });

    // Save design
    document.getElementById('save-design-btn').addEventListener('click', () => {
      this.saveDesign();
    });

    // Clear design
    document.getElementById('clear-design-btn').addEventListener('click', () => {
      this.clearDesign();
    });

    // Add to cart
    document.getElementById('add-to-cart-btn').addEventListener('click', () => {
      this.addToCart();
    });

    // Update stitch estimate when design changes
    document.getElementById('text-input').addEventListener('input', () => {
      this.updateStitchEstimate();
    });
  }

  addText() {
    const text = document.getElementById('text-input').value;
    const fontFamily = document.getElementById('font-family').value;
    const fontSize = document.getElementById('font-size').value;
    const color = document.getElementById('text-color').value;

    if (!text.trim()) {
      alert('Please enter some text');
      return;
    }

    const textElement = document.createElement('div');
    textElement.className = 'design-text';
    textElement.style.cssText = `
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      font-family: ${fontFamily};
      font-size: ${fontSize}px;
      color: ${color};
      cursor: move;
      pointer-events: auto;
      user-select: none;
      z-index: 10;
    `;
    textElement.textContent = text;

    // Make text draggable
    this.makeDraggable(textElement);

    this.overlay.appendChild(textElement);

    // Store in design data
    this.currentDesign.text.push({
      text: text,
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      x: 50, // percentage
      y: 50  // percentage
    });

    // Clear input
    document.getElementById('text-input').value = '';

    // Update stitch estimate
    this.updateStitchEstimate();
  }

  addLogo() {
    const fileInput = document.getElementById('logo-upload');
    if (!fileInput.files || !fileInput.files[0]) {
      alert('Please select a logo file first');
      return;
    }

    const file = fileInput.files[0];
    const reader = new FileReader();

    reader.onload = (e) => {
      const logoElement = document.createElement('img');
      logoElement.className = 'design-logo';
      logoElement.src = e.target.result;
      logoElement.style.cssText = `
        position: absolute;
        top: 30%;
        left: 30%;
        max-width: 100px;
        max-height: 100px;
        cursor: move;
        pointer-events: auto;
        z-index: 10;
      `;

      // Make logo draggable and resizable
      this.makeDraggable(logoElement);
      this.makeResizable(logoElement);

      this.overlay.appendChild(logoElement);

      // Store in design data
      this.currentDesign.logos.push({
        src: e.target.result,
        x: 30,
        y: 30,
        width: 100,
        height: 100
      });

      // Update stitch estimate
      this.updateStitchEstimate();
    };

    reader.readAsDataURL(file);
  }

  makeDraggable(element) {
    let isDragging = false;
    let startX, startY, startLeft, startTop;

    element.addEventListener('mousedown', (e) => {
      isDragging = true;
      startX = e.clientX;
      startY = e.clientY;
      startLeft = parseInt(element.style.left) || 0;
      startTop = parseInt(element.style.top) || 0;
      e.preventDefault();
    });

    document.addEventListener('mousemove', (e) => {
      if (!isDragging) return;

      const deltaX = e.clientX - startX;
      const deltaY = e.clientY - startY;

      element.style.left = (startLeft + deltaX) + 'px';
      element.style.top = (startTop + deltaY) + 'px';
    });

    document.addEventListener('mouseup', () => {
      isDragging = false;
    });
  }

  makeResizable(element) {
    // Add resize handles
    const resizeHandle = document.createElement('div');
    resizeHandle.style.cssText = `
      position: absolute;
      bottom: -5px;
      right: -5px;
      width: 10px;
      height: 10px;
      background: #007bff;
      cursor: se-resize;
      z-index: 11;
    `;
    element.appendChild(resizeHandle);

    let isResizing = false;
    let startX, startY, startWidth, startHeight;

    resizeHandle.addEventListener('mousedown', (e) => {
      isResizing = true;
      startX = e.clientX;
      startY = e.clientY;
      startWidth = parseInt(document.defaultView.getComputedStyle(element).width, 10);
      startHeight = parseInt(document.defaultView.getComputedStyle(element).height, 10);
      e.preventDefault();
      e.stopPropagation();
    });

    document.addEventListener('mousemove', (e) => {
      if (!isResizing) return;

      const width = startWidth + e.clientX - startX;
      const height = startHeight + e.clientY - startY;

      element.style.width = Math.max(20, width) + 'px';
      element.style.height = Math.max(20, height) + 'px';
    });

    document.addEventListener('mouseup', () => {
      isResizing = false;
    });
  }

  updateStitchEstimate() {
    // Simple stitch estimation algorithm
    let totalStitches = 0;

    // Estimate stitches for text
    this.currentDesign.text.forEach(textItem => {
      const charCount = textItem.text.length;
      const fontSize = parseInt(textItem.fontSize);
      // Rough estimate: 100 stitches per character for average font size
      const stitchesPerChar = Math.max(50, fontSize * 2);
      totalStitches += charCount * stitchesPerChar;
    });

    // Estimate stitches for logos (more complex)
    this.currentDesign.logos.forEach(logo => {
      // Rough estimate based on logo size
      const area = logo.width * logo.height;
      const complexity = Math.min(area / 100, 1000); // Cap complexity
      totalStitches += complexity * 50; // 50 stitches per complexity unit
    });

    // Update display
    document.getElementById('stitch-count').textContent = totalStitches.toLocaleString();

    // Calculate cost (example: $0.35 per 1000 stitches)
    const cost = (totalStitches / 1000) * 0.35;
    document.getElementById('embroidery-cost').textContent = '$' + cost.toFixed(2);
  }

  saveDesign() {
    // Save design to server
    const designData = {
      product_id: this.getProductId(),
      design_data: JSON.stringify(this.currentDesign),
      stitch_count: this.getStitchCount(),
      estimated_cost: this.getEstimatedCost()
    };

    fetch('/api/v1/customizations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.getCSRFToken()
      },
      body: JSON.stringify(designData)
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('Design saved successfully!');
      } else {
        alert('Error saving design: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error saving design');
    });
  }

  clearDesign() {
    if (confirm('Are you sure you want to clear the current design?')) {
      this.overlay.innerHTML = '';
      this.currentDesign = { text: [], images: [], logos: [] };
      this.updateStitchEstimate();
    }
  }

  addToCart() {
    // First save the design, then add to cart
    this.saveDesign();
    
    // Add product with customization to cart
    const productId = this.getProductId();
    const customizationData = {
      design_data: JSON.stringify(this.currentDesign),
      stitch_count: this.getStitchCount(),
      estimated_cost: this.getEstimatedCost()
    };

    fetch(`/cart/add/${productId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.getCSRFToken()
      },
      body: JSON.stringify({
        quantity: 1,
        customization: customizationData
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('Product added to cart with custom design!');
        // Update cart count in header
        this.updateCartCount();
      } else {
        alert('Error adding to cart: ' + data.error);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Error adding to cart');
    });
  }

  // Helper methods
  getProductId() {
    return document.querySelector('[data-product-id]')?.dataset.productId || 1;
  }

  getStitchCount() {
    return parseInt(document.getElementById('stitch-count').textContent.replace(/,/g, '')) || 0;
  }

  getEstimatedCost() {
    return parseFloat(document.getElementById('embroidery-cost').textContent.replace('$', '')) || 0;
  }

  getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
  }

  updateCartCount() {
    // Update cart count in header
    const cartCount = document.getElementById('cart-count');
    if (cartCount) {
      const currentCount = parseInt(cartCount.textContent) || 0;
      cartCount.textContent = currentCount + 1;
    }
  }
}

// Export for use in other files
window.ProductDesigner = ProductDesigner;