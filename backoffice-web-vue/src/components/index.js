
import Vue from 'vue';

// Chat
import ChatPage from './Chat/ChatPage';

// Button
import PrinterButton from './custom/button/PrinterButton';
import TwinkleWarningButton from './custom/button/TwinkleWarningButton';

// Custom/item
import CooperatorItem from './custom/item/CooperatorItem';
import FactoryItem from './custom/item/FactoryItem';

// Custom/order-form
import MTAVAT from './custom/order-form/MTAVAT';
import AddressForm from './custom/order-form/AddressForm';
import MyAddressForm from './custom/order-form/MyAddressForm';
import MyPayPlanForm from './custom/order-form/MyPayPlanForm';
import PayPlanFormV2 from './custom/order-form/PayPlanFormV2';
import PayPlanInfo from '@/components/custom/order-form/PayPlanInfo';
import CompanySelect from '@/components/custom/order-form/CompanySelect';

// table
import ColorSizeTable from '@/components/custom/table/ColorSizeTable'
import ColorSizeBoxTable from '@/components/custom/table/ColorSizeBoxTable'
import ColorSizeBoxChangeTable from '@/components/custom/table/ColorSizeBoxChangeTable'
import ColorSizeChangeTable from '@/components/custom/table/ColorSizeChangeTable'

// Custom/upload
import PDFUpload from './custom/upload/PDFUpload';
import PdfPreview from './custom/upload/PdfPreview'

import Aside from './Aside.vue';
import Breadcrumb from './Breadcrumb.vue';
import Callout from './Callout.vue';
import AppHeader from './AppHeader.vue';
import Sidebar from './Sidebar/Sidebar.vue';
import Switch from './Switch.vue';
import SideSlider from './SideSlider';
import TagsView from './TagsView';

// Custom
import AddressSelect from './custom/AddressSelect';
import ApprovalStatus from './custom/ApprovalStatus';
import CategorySelect from './custom/CategorySelect';
import ConsignmentForm from './custom/ConsignmentForm';
import DeliverForm from './custom/DeliverForm';
import DjCheckbox from './custom/DjCheckbox';
import DjTag from './custom/DjTag';
import AuditTag from './custom/AuditTag';
import EmployeeSelect from './custom/EmployeeSelect';
import EnumSelect from './custom/EnumSelect';
import FactoryCooperatorTransfer from './custom/FactoryCooperatorTransfer';
import FilesUpload from './custom/FilesUpload';
import FormLabel from './custom/FormLabel';
import DjMultipleSelect from './custom/DjSelect/DjMultipleSelect'
import DeptPersonSelect from './custom/DjComplexSelect/DeptPersonSelect'
import DeptSelection from './custom/DjComplexSelect/DeptSelection'
import PersonnalSelectionV2 from './custom/DjComplexSelect/PersonnalSelectionV2'

// import ImagesCropper from './custom/ImagesCropper';
import ImagesUpload from './custom/ImagesUpload';
import ImagesUploadSingle from './custom/ImagesUploadSingle';
import ImagesUploadText from './custom/ImagesUploadText';
import MediaFileList from './custom/MediaFileList';
import OrdersInfoItem from './custom/OrdersInfoItem';
import OrdersInfoTable from './custom/OrdersInfoTable';
import PayPlanForm from './custom/PayPlanForm';
import PayPlanSelect from './custom/PayPlanSelect';
import PersonnelSelection from './custom/PersonnelSelection';
import ProductSelect from './custom/ProductSelect';
import SupplierSelect from './custom/SupplierSelect';
import TabLabelBubble from './custom/TabLabelBubble';
import TagsOfText from './custom/TagsOfText';
import TextToInput from './custom/TextToInput';
import UniquecodeGenerateForm from './custom/UniquecodeGenerateForm';
import UniquecodeImportForm from './custom/UniquecodeImportForm';
import WarningProgress from './custom/WarningProgress';
import SelectTree from './custom/SelectTree'

// Header
import HeaderDropdownAccnt from './Header/HeaderDropdownAccnt';

// webchat
import main from './webchat/main';

//excel
import UploadExcelComponent from './UploadExcel/index';


export {
  ChatPage,
  //Button
  PrinterButton,
  TwinkleWarningButton,
  //
  CooperatorItem,
  FactoryItem,
  MTAVAT,
  MyAddressForm,
  MyPayPlanForm,
  PayPlanFormV2,
  PayPlanInfo,
  CompanySelect,
  PDFUpload,
  AddressForm,
  AddressSelect,
  ApprovalStatus,
  CategorySelect,
  ConsignmentForm,
  DeliverForm,
  DjCheckbox,
  DjTag,
  AuditTag,
  EmployeeSelect,
  EnumSelect,
  FactoryCooperatorTransfer,
  FilesUpload,
  FormLabel,
  // ImagesCropper,
  ImagesUpload,
  ImagesUploadSingle,
  ImagesUploadText,
  MediaFileList,
  OrdersInfoItem,
  OrdersInfoTable,
  PayPlanForm,
  PayPlanSelect,
  PersonnelSelection,
  ProductSelect,
  SupplierSelect,
  TabLabelBubble,
  TagsOfText,
  TextToInput,
  UniquecodeGenerateForm,
  UniquecodeImportForm,
  WarningProgress,
  HeaderDropdownAccnt,
  main,
  Aside,
  Breadcrumb,
  Callout,
  AppHeader,
  Sidebar,
  TagsView,
  Switch,
  SideSlider,
  ColorSizeTable,
  ColorSizeBoxTable,
  ColorSizeBoxChangeTable,
  ColorSizeChangeTable,
  SelectTree,
  DjMultipleSelect,
  DeptPersonSelect,
  DeptSelection,
  PersonnalSelectionV2,
  PdfPreview,
  //excel
  UploadExcelComponent
}

//全局注册组件
Vue.component("AuditTag", AuditTag);
